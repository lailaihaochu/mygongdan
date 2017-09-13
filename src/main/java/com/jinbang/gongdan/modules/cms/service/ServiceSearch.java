package com.jinbang.gongdan.modules.cms.service;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.utils.Reflections;
import com.jinbang.gongdan.common.utils.StringUtils;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.search.highlight.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.cms.dao.ArticleDao;
import com.jinbang.gongdan.modules.cms.dao.GuestbookDao;
import com.jinbang.gongdan.modules.cms.entity.Article;
import com.jinbang.gongdan.modules.cms.entity.Category;
import com.jinbang.gongdan.modules.cms.entity.Guestbook;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import org.wltea.analyzer.lucene.IKAnalyzer;

@Service
@Transactional(readOnly = true)
public class ServiceSearch extends CrudService<ArticleDao, Article> {
    @Autowired
    private ArticleDao articleDAO;
    @Autowired
    private GuestbookDao guestbookDao;

    private final String INDEXPATHARTICLE = Global.getConfig("index_article_path");
    private final String INDEXPATHGUESTBOOK = Global.getConfig("index_guestbook_path");
    private Analyzer analyzer = new StandardAnalyzer();

    // 将检索到的数据进行分页
    public Page<Article> find(Page<Article> page, Article article, List<Article> qlist) {
        article.setPage(page);
        page.setList(qlist);
        return page;
    }

    // 将检索到的数据进行分页
    public Page<Guestbook> find(Page<Guestbook> page, Guestbook article, List<Guestbook> qlist) {
        article.setPage(page);
        page.setList(qlist);
        return page;
    }

    /**
     *
     * @Title getArticles TODO(获取文章索引内容). <br/>
     * @author Xtra.极致丨
     * @param @param page
     * @param @param query
     * @param @return 参数说明
     * @return Page<Article> 返回类型
     * @date 2016年6月21日
     */
    public Page<Article> getArticles(Page<Article> page, String query) {

        try {
            List<Article> qlist = new ArrayList<Article>();
            String fieldName = "title";
            IndexSearcher indexSearcher = new IndexSearcher(INDEXPATHARTICLE);
            // QueryParser parser = new QueryParser(fieldName, analyzer); //单
            // key 搜索
            // Query queryOBJ = parser.parse(query);
            System.out.println(">>> 2.开始读取索引... ... 通过关键字：【 " + query + " 】");
            long beginTime = new Date().getTime();

            // 下面的是进行title,content 两个范围内进行收索.
            BooleanClause.Occur[] clauses = { BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD };
            Query queryOBJ = MultiFieldQueryParser.parse(query, new String[] { "title", "content" }, clauses, new StandardAnalyzer());// parser.parse(query);
            Filter filter = null;
            // ################# 搜索相似度最高的记录 ###################
            TopDocs topDocs = indexSearcher.search(queryOBJ, filter, 1000);
            // TopDocs topDocs = indexSearcher.search(queryOBJ , 10000);
            System.out.println("*** 共匹配：" + topDocs.totalHits + "个 ***");
            Article article = null;

            ScoreDoc[] scoreDocs = topDocs.scoreDocs;
            // 查询起始记录位置
            int begin = page.getPageNo() - 1;// 当前页
            // 查询终止记录位置
            int end = Math.min(begin + page.getPageSize(), scoreDocs.length);// page.getPageSize()：没页条数，scoreDocs.length：总条数
            for (int i = begin; i < end; i++) {
                int docId = scoreDocs[i].doc;
                Document document = indexSearcher.doc(docId);
                article = new Article();
                // 设置高亮显示格式
                SimpleHTMLFormatter simpleHTMLFormatter = new SimpleHTMLFormatter("<font color='red'><strong>", "</strong></font>");
				/* 语法高亮显示设置 */
                Highlighter highlighter = new Highlighter(simpleHTMLFormatter, new QueryScorer(queryOBJ));
                highlighter.setTextFragmenter(new SimpleFragmenter(100));
                // 设置高亮 设置 title,content 字段
                String title = document.get("title");
                String content = document.get("content");
                String category_id = document.get("category_id");
                String id = document.get("id");
                String hits = document.get("hits");
                String createDate = document.get("createDate");
                String updateDate = document.get("updateDate");
                String cteateBy = document.get("cteateBy");
                TokenStream titleTokenStream = analyzer.tokenStream(fieldName, new StringReader(title));
                TokenStream contentTokenStream = analyzer.tokenStream("content", new StringReader(content));
                String highLightTitle = highlighter.getBestFragment(titleTokenStream, title);
                String highLightContent = highlighter.getBestFragment(contentTokenStream, content);

                if (highLightTitle == null)
                    highLightTitle = title;

                if (highLightContent == null)
                    highLightContent = content;

                // 将检索的结果绑定到对象
                article.setTitle(highLightTitle);
                article.setDescription(highLightContent);
                article.setCategory(new Category(category_id));
                article.setId(id);
                // if(null!=hits&&!hits.equals(""))
                article.setHits(Integer.parseInt(hits));
                SystemService ss = new SystemService();
                article.setCreateBy(ss.getUser(cteateBy));
                article.setCreateDate(DateUtils.parseDate(createDate));
                article.setUpdateDate(DateUtils.parseDate(updateDate));

                // 把对象添加到list
                qlist.add(article);
            }

            // 输出结果
            for (ScoreDoc scoreDoc : topDocs.scoreDocs) {
                Document targetDoc = indexSearcher.doc(scoreDoc.doc);
                article = new Article();
                // 设置高亮显示格式
                SimpleHTMLFormatter simpleHTMLFormatter = new SimpleHTMLFormatter("<font color='red'><strong>", "</strong></font>");
				/* 语法高亮显示设置 */
                Highlighter highlighter = new Highlighter(simpleHTMLFormatter, new QueryScorer(queryOBJ));
                highlighter.setTextFragmenter(new SimpleFragmenter(100));
                // 设置高亮 设置 title,content 字段
                String id = targetDoc.get("id");
                String title = targetDoc.get("title");
                String content = targetDoc.get("content");
                String category_id = targetDoc.get("category_id");
                TokenStream titleTokenStream = analyzer.tokenStream(fieldName, new StringReader(title));
                TokenStream contentTokenStream = analyzer.tokenStream("content", new StringReader(content));
                String highLightTitle = highlighter.getBestFragment(titleTokenStream, title);
                String highLightContent = highlighter.getBestFragment(contentTokenStream, content);

                if (highLightTitle == null)
                    highLightTitle = title;

                if (highLightContent == null)
                    highLightContent = content;

                article.setTitle(highLightTitle);
                article.setDescription(highLightContent);
                article.setId(id);
                article.setCategory(new Category(category_id));
                qlist.add(article);
            }

            long endTime = new Date().getTime();
            System.out.println(">>> 3.搜索完毕... ... 共花费：" + (endTime - beginTime) + "毫秒...");
            indexSearcher.close();

            // return qlist;
            if (article == null)
                return null;
            else {
                page.setCount(topDocs.totalHits);
                return find(page, article, qlist);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @Title createIndex TODO(创建索引). <br/>
     * @author Xtra.极致丨
     * @param @return 参数说明
     * @return boolean 返回类型
     * @date 2016年6月21日
     */
    public boolean createIndex() {
        // 检查索引是否存在
        if (!this.isIndexExisted())
            return this.isIndexExisted();

        List<Article> list = articleDAO.findAllList(new Article());
        try {
            Directory directory = FSDirectory.getDirectory(INDEXPATHARTICLE);
            IndexWriter indexWriter = new IndexWriter(directory, analyzer, true, IndexWriter.MaxFieldLength.LIMITED);

            long begin = new Date().getTime();
            for (Article art : list) {
                // 创建索引库的文档,添加需要存放的列
                Document doc = new Document();
                String title = art.getTitle() == null ? "" : art.getTitle().trim();
                String content = art.getDescription() == null ? "" : art.getDescription();
                String category_id = art.getCategory().getId() == null ? "" : art.getCategory().getId();
                String id = art.getId() == null ? "" : art.getId().trim();
                String hits = art.getHits() == null ? "0" : art.getHits() + "";
                // 需要将日期格式化
                String createDate = art.getCreateDate() == null ? "" : DateUtils.formatDateTime(art.getCreateDate());
                String updateDate = art.getUpdateDate() == null ? "" : DateUtils.formatDateTime(art.getUpdateDate());
                // 这里cteateBy 为用户的ID
                String cteateBy = art.getCreateBy().getId() == null ? "" : art.getCreateBy().getId();

                doc.add(new Field("title", title, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("content", content, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("category_id", category_id, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("id", id, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("hits", hits, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("createDate", createDate, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("updateDate", updateDate, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("cteateBy", cteateBy, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                indexWriter.addDocument(doc);
            }
            long end = new Date().getTime();
            System.out.println(">>> 1.存入索引完毕.. 共花费：" + (end - begin) + "毫秒...");

            indexWriter.optimize();
            indexWriter.close();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createIndexGuestBook() {
        // 检查索引是否存在
        if (!this.isIndexExisted())
            return this.isIndexExisted();

        List<Guestbook> list = guestbookDao.findAllList(new Guestbook());
        try {
            Directory directory = FSDirectory.getDirectory(INDEXPATHGUESTBOOK);
            IndexWriter indexWriter = new IndexWriter(directory, analyzer, true, IndexWriter.MaxFieldLength.LIMITED);

            long begin = new Date().getTime();
            for (Guestbook art : list) {
                // 创建索引库的文档,添加需要存放的列
                Document doc = new Document();
                String content = art.getContent() == null ? "" : art.getContent();
                String name = art.getName() == null ? "" : art.getName();
                String reContent = art.getReContent() == null ? "" : art.getReContent();
                String reUserId = art.getReUser().getId() == null ? "" : art.getReUser().getId();
                String reDate = art.getReDate() == null ? "" : DateUtils.formatDateTime(art.getReDate());
                // String category_id = art.getCategory().getId() == null ? "" :
                // art.getCategory().getId();
                String id = art.getId() == null ? "" : art.getId();
                // 需要将日期格式化
                String createDate = art.getCreateDate() == null ? "" : DateUtils.formatDateTime(art.getCreateDate());
                String updateDate = art.getUpdateDate() == null ? "" : DateUtils.formatDateTime(art.getUpdateDate());
                // 这里cteateBy 为用户的ID
                // String cteateBy = art.getCreateBy().getId() == null ? "" :
                // art.getCreateBy().getId();

                doc.add(new Field("id", id, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("content", content, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("reContent", reContent, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("name", name, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("reUserId", reUserId, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("reDate", reDate, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("createDate", createDate, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                doc.add(new Field("updateDate", updateDate, Field.Store.YES, Field.Index.ANALYZED, Field.TermVector.YES));
                indexWriter.addDocument(doc);
            }
            long end = new Date().getTime();
            System.out.println(">>> 1.存入索引完毕.. 共花费：" + (end - begin) + "毫秒...");

            indexWriter.optimize();
            indexWriter.close();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Page<Guestbook> getGuestBook(Page<Guestbook> page, String query) {

        try {
            List<Guestbook> qlist = new ArrayList<Guestbook>();
            String fieldName = "content";
            IndexSearcher indexSearcher = new IndexSearcher(INDEXPATHGUESTBOOK);
            // QueryParser parser = new QueryParser(fieldName, analyzer); //单
            // key 搜索
            // Query queryOBJ = parser.parse(query);
            System.out.println(">>> 2.开始读取索引... ... 通过关键字：【 " + query + " 】");
            long beginTime = new Date().getTime();
            // 下面的是进行title,content 两个范围内进行收索.
            BooleanClause.Occur[] clauses = { BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD };
            Query queryOBJ = MultiFieldQueryParser.parse(query, new String[] { "name", "content" }, clauses, new StandardAnalyzer());// parser.parse(query);
            Filter filter = null;
            // ################# 搜索相似度最高的记录 ###################
            TopDocs topDocs = indexSearcher.search(queryOBJ, filter, 1000);
            // TopDocs topDocs = indexSearcher.search(queryOBJ , 10000);
            System.out.println("*** 共匹配：" + topDocs.totalHits + "个 ***");
            Guestbook article = null;

            ScoreDoc[] scoreDocs = topDocs.scoreDocs;
            // 查询起始记录位置
            int begin = page.getPageNo() - 1;// 当前页
            // 查询终止记录位置
            int end = Math.min(begin + page.getPageSize(), scoreDocs.length);// page.getPageSize()：没页条数，scoreDocs.length：总条数
            for (int i = begin; i < end; i++) {
                int docId = scoreDocs[i].doc;
                Document document = indexSearcher.doc(docId);
                article = new Guestbook();
                // 设置高亮显示格式
                SimpleHTMLFormatter simpleHTMLFormatter = new SimpleHTMLFormatter("<font color='red'><strong>", "</strong></font>");
				/* 语法高亮显示设置 */
                Highlighter highlighter = new Highlighter(simpleHTMLFormatter, new QueryScorer(queryOBJ));
                highlighter.setTextFragmenter(new SimpleFragmenter(100));
                // 设置高亮 设置 name,content 字段
                String reContent = document.get("reContent");
                String reUserId = document.get("reUserId");
                String reDate = document.get("reDate");
                String content = document.get("content");
                String name = document.get("name");
                String createDate = document.get("createDate");
                String updateDate = document.get("updateDate");
                TokenStream contentTokenStream = analyzer.tokenStream(fieldName, new StringReader(content));
                TokenStream nameTokenStream = analyzer.tokenStream("name", new StringReader(name));
                String highLightContent = highlighter.getBestFragment(contentTokenStream, content);
                String highLightName = highlighter.getBestFragment(nameTokenStream, name);

                if (highLightContent == null)
                    highLightContent = content;

                if (highLightName == null)
                    highLightName = name;

                // 将检索的结果绑定到对象
                article.setContent(highLightContent);
                article.setName(highLightName);
                article.setReContent(reContent);
                SystemService ss = new SystemService();
                article.setReUser(ss.getUser(reUserId));
                article.setReDate(DateUtils.parseDate(reDate));
                // if(null!=hits&&!hits.equals(""))
                article.setCreateDate(DateUtils.parseDate(createDate));
                article.setUpdateDate(DateUtils.parseDate(updateDate));

                // 把对象添加到list
                qlist.add(article);
            }

            // 输出结果
            for (ScoreDoc scoreDoc : topDocs.scoreDocs) {
                Document targetDoc = indexSearcher.doc(scoreDoc.doc);
                article = new Guestbook();
                // 设置高亮显示格式
                SimpleHTMLFormatter simpleHTMLFormatter = new SimpleHTMLFormatter("<font color='red'><strong>", "</strong></font>");
				/* 语法高亮显示设置 */
                Highlighter highlighter = new Highlighter(simpleHTMLFormatter, new QueryScorer(queryOBJ));
                highlighter.setTextFragmenter(new SimpleFragmenter(100));
                // 设置高亮 设置 title,content 字段
                String name = targetDoc.get("name");
                String content = targetDoc.get("content");
                TokenStream nameTokenStream = analyzer.tokenStream(fieldName, new StringReader(name));
                TokenStream contentTokenStream = analyzer.tokenStream("content", new StringReader(content));
                String highLightName = highlighter.getBestFragment(nameTokenStream, name);
                String highLightContent = highlighter.getBestFragment(contentTokenStream, content);

                if (highLightName == null)
                    highLightName = name;

                if (highLightContent == null)
                    highLightContent = content;

                article.setContent(content);
                article.setName(name);
                qlist.add(article);
            }

            long endTime = new Date().getTime();
            System.out.println(">>> 3.搜索完毕... ... 共花费：" + (endTime - beginTime) + "毫秒...");
            indexSearcher.close();

            // return qlist;
            if (article == null)
                return null;
            else {
                page.setCount(topDocs.totalHits);
                return find(page, article, qlist);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * check Index is Existed
     *
     * @return true or false
     */
    private boolean isIndexExisted() {
        try {
            File dir1 = new File(INDEXPATHARTICLE);
            File dir2 = new File(INDEXPATHGUESTBOOK);
            // if (dir.listFiles().length > 0)
            if (dir1.exists() && dir2.exists())
                return true;
            else
                return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    /**
     * 获取全文查询对象
     */
    public BooleanQuery getFullTextQuery(BooleanClause... booleanClauses){
        BooleanQuery booleanQuery = new BooleanQuery();
        for (BooleanClause booleanClause : booleanClauses){
            booleanQuery.add(booleanClause);
        }
        return booleanQuery;
    }

    /**
     * 获取全文查询对象
     * @param q 查询关键字
     * @param fields 查询字段
     * @return 全文查询对象
     */
    public BooleanQuery getFullTextQuery(String q, String... fields){
        Analyzer analyzer = new IKAnalyzer();
        BooleanQuery query = new BooleanQuery();
        try {
            if (StringUtils.isNotBlank(q)){
                for (String field : fields){
                    QueryParser parser = new QueryParser(Version.LUCENE_CURRENT, field, analyzer);
                    query.add(parser.parse(q), BooleanClause.Occur.SHOULD);
                }
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return query;
    }


}