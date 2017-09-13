
package com.jinbang.gongdan.common.utils.excel;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.Encodes;
import com.jinbang.gongdan.common.utils.Reflections;
import com.jinbang.gongdan.common.utils.excel.annotation.ExcelField;
import com.jinbang.gongdan.modules.sys.utils.DictUtils;
import com.jinbang.gongdan.modules.wo.entity.PoRecord;
import com.jinbang.gongdan.modules.wo.entity.WoFeeItem;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.*;

/**
 * 导出Excel文件（导出“XLSX”格式，支持大数据量导出   @see org.apache.poi.ss.SpreadsheetVersion）
 */
public class ExportExcel {
	
	private static Logger log = LoggerFactory.getLogger(ExportExcel.class);
			
	/**
	 * 工作薄对象
	 */
	private SXSSFWorkbook wb;
	
	/**
	 * 工作表对象
	 */
	private Sheet sheet;
	
	/**
	 * 样式列表
	 */
	private Map<String, CellStyle> styles;
	
	/**
	 * 当前行号
	 */
	private int rownum;
	
	/**
	 * 注解列表（Object[]{ ExcelField, Field/Method }）
	 */
	List<Object[]> annotationList = Lists.newArrayList();
	
	/**
	 * 构造函数
	 * @param title 表格标题，传“空值”，表示无标题
	 * @param cls 实体对象，通过annotation.ExportField获取标题
	 */
	public ExportExcel(String title, Class<?> cls){
		this(title, cls, 1);
	}
	
	/**
	 * 构造函数
	 * @param title 表格标题，传“空值”，表示无标题
	 * @param cls 实体对象，通过annotation.ExportField获取标题
	 * @param type 导出类型（1:导出数据；2：导出模板）
	 * @param groups 导入分组
	 */
	public ExportExcel(String title, Class<?> cls, int type, int... groups){
		// Get annotation field 
		Field[] fs = cls.getDeclaredFields();
		for (Field f : fs){
			ExcelField ef = f.getAnnotation(ExcelField.class);
			if (ef != null && (ef.type()==0 || ef.type()==type)){
				if (groups!=null && groups.length>0){
					boolean inGroup = false;
					for (int g : groups){
						if (inGroup){
							break;
						}
						for (int efg : ef.groups()){
							if (g == efg){
								inGroup = true;
								annotationList.add(new Object[]{ef, f});
								break;
							}
						}
					}
				}else{
					annotationList.add(new Object[]{ef, f});
				}
			}
		}
		// Get annotation method
		Method[] ms = cls.getDeclaredMethods();
		for (Method m : ms){
			ExcelField ef = m.getAnnotation(ExcelField.class);
			if (ef != null && (ef.type()==0 || ef.type()==type)){
				if (groups!=null && groups.length>0){
					boolean inGroup = false;
					for (int g : groups){
						if (inGroup){
							break;
						}
						for (int efg : ef.groups()){
							if (g == efg){
								inGroup = true;
								annotationList.add(new Object[]{ef, m});
								break;
							}
						}
					}
				}else{
					annotationList.add(new Object[]{ef, m});
				}
			}
		}
		// Field sorting
		Collections.sort(annotationList, new Comparator<Object[]>() {
			public int compare(Object[] o1, Object[] o2) {
				return new Integer(((ExcelField)o1[0]).sort()).compareTo(
						new Integer(((ExcelField)o2[0]).sort()));
			};
		});
		// Initialize
		List<String> headerList = Lists.newArrayList();
		for (Object[] os : annotationList){
			String t = ((ExcelField)os[0]).title();
			// 如果是导出，则去掉注释
			if (type==1){
				String[] ss = StringUtils.split(t, "**", 2);
				if (ss.length==2){
					t = ss[0];
				}
			}
			headerList.add(t);
		}
		initialize(title, headerList);
	}
	
	/**
	 * 构造函数
	 * @param title 表格标题，传“空值”，表示无标题
	 * @param headers 表头数组
	 */
	public ExportExcel(String title, String[] headers) {
		initialize(title, Lists.newArrayList(headers));
	}
	
	/**
	 * 构造函数
	 * @param title 表格标题，传“空值”，表示无标题
	 * @param headerList 表头列表
	 */
	public ExportExcel(String title, List<String> headerList) {
		initialize(title, headerList);
	}
	
	/**
	 * 初始化函数
	 * @param title 表格标题，传“空值”，表示无标题
	 * @param headerList 表头列表
	 */
	private void initialize(String title, List<String> headerList) {
		this.wb = new SXSSFWorkbook(500);
		this.sheet = wb.createSheet("Export");
		this.styles = createStyles(wb);
		// Create title
		if (StringUtils.isNotBlank(title)){
			Row titleRow = sheet.createRow(rownum++);
			titleRow.setHeightInPoints(30);
			Cell titleCell = titleRow.createCell(0);
			titleCell.setCellStyle(styles.get("title"));
			titleCell.setCellValue(title);
			sheet.addMergedRegion(new CellRangeAddress(titleRow.getRowNum(),
					titleRow.getRowNum(), titleRow.getRowNum(), headerList.size()-1));
		}
		// Create header
		if (headerList == null){
			throw new RuntimeException("headerList not null!");
		}
		Row headerRow = sheet.createRow(rownum++);
		headerRow.setHeightInPoints(16);
		for (int i = 0; i < headerList.size(); i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellStyle(styles.get("header"));
			String[] ss = StringUtils.split(headerList.get(i), "**", 2);
			if (ss.length==2){
				cell.setCellValue(ss[0]);
				Comment comment = this.sheet.createDrawingPatriarch().createCellComment(
						new XSSFClientAnchor(0, 0, 0, 0, (short) 3, 3, (short) 5, 6));
				comment.setString(new XSSFRichTextString(ss[1]));
				cell.setCellComment(comment);
			}else{
				cell.setCellValue(headerList.get(i));
			}
			sheet.autoSizeColumn(i);
		}
		for (int i = 0; i < headerList.size(); i++) {  
			int colWidth = sheet.getColumnWidth(i)*2;
	        sheet.setColumnWidth(i, colWidth < 3000 ? 3000 : colWidth);  
		}
		log.debug("Initialize success.");
	}
	
	/**
	 * 创建表格样式
	 * @param wb 工作薄对象
	 * @return 样式列表
	 */
	private Map<String, CellStyle> createStyles(Workbook wb) {
		Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
		
		CellStyle style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		Font titleFont = wb.createFont();
		titleFont.setFontName("Arial");
		titleFont.setFontHeightInPoints((short) 16);
		titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		style.setFont(titleFont);
		styles.put("title", style);

		style = wb.createCellStyle();
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		Font dataFont = wb.createFont();
		dataFont.setFontName("Arial");
		dataFont.setFontHeightInPoints((short) 10);
		style.setFont(dataFont);
		styles.put("data", style);
		
		style = wb.createCellStyle();
		style.cloneStyleFrom(styles.get("data"));
		style.setAlignment(CellStyle.ALIGN_LEFT);
		styles.put("data1", style);

		style = wb.createCellStyle();
		style.cloneStyleFrom(styles.get("data"));
		style.setAlignment(CellStyle.ALIGN_CENTER);
		styles.put("data2", style);

		style = wb.createCellStyle();
		style.cloneStyleFrom(styles.get("data"));
		style.setAlignment(CellStyle.ALIGN_RIGHT);
		styles.put("data3", style);
		
		style = wb.createCellStyle();
		style.cloneStyleFrom(styles.get("data"));
//		style.setWrapText(true);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		Font headerFont = wb.createFont();
		headerFont.setFontName("Arial");
		headerFont.setFontHeightInPoints((short) 10);
		headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		headerFont.setColor(IndexedColors.WHITE.getIndex());
		style.setFont(headerFont);
		styles.put("header", style);
		
		return styles;
	}

	/**
	 * 添加一行
	 * @return 行对象
	 */
	public Row addRow(){
		return sheet.createRow(rownum++);
	}
	

	/**
	 * 添加一个单元格
	 * @param row 添加的行
	 * @param column 添加列号
	 * @param val 添加值
	 * @return 单元格对象
	 */
	public Cell addCell(Row row, int column, Object val){
		return this.addCell(row, column, val, 0, Class.class);
	}
	
	/**
	 * 添加一个单元格
	 * @param row 添加的行
	 * @param column 添加列号
	 * @param val 添加值
	 * @param align 对齐方式（1：靠左；2：居中；3：靠右）
	 * @return 单元格对象
	 */
	public Cell addCell(Row row, int column, Object val, int align, Class<?> fieldType){
		Cell cell = row.createCell(column);
		CellStyle style = styles.get("data"+(align>=1&&align<=3?align:""));
		try {
			if (val == null){
				cell.setCellValue("");
			} else if (val instanceof String) {
				cell.setCellValue((String) val);
			} else if (val instanceof Integer) {
				cell.setCellValue((Integer) val);
			} else if (val instanceof Long) {
				cell.setCellValue((Long) val);
			} else if (val instanceof Double) {
				cell.setCellValue((Double) val);
			} else if (val instanceof Float) {
				cell.setCellValue((Float) val);
			} else if (val instanceof Date) {
				DataFormat format = wb.createDataFormat();
	            style.setDataFormat(format.getFormat("yyyy-MM-dd"));
				cell.setCellValue((Date) val);
			} else {
				if (fieldType != Class.class){
					cell.setCellValue((String)fieldType.getMethod("setValue", Object.class).invoke(null, val));
				}else{
					cell.setCellValue((String)Class.forName(this.getClass().getName().replaceAll(this.getClass().getSimpleName(), 
						"fieldtype."+val.getClass().getSimpleName()+"Type")).getMethod("setValue", Object.class).invoke(null, val));
				}
			}
		} catch (Exception ex) {
			log.info("Set cell value ["+row.getRowNum()+","+column+"] error: " + ex.toString());
			cell.setCellValue(val.toString());
		}
		cell.setCellStyle(style);
		return cell;
	}
	public Cell addCell(Row row,int rowFrom,int rowTo,int columnFrom ,int columnTo,Object val, CellStyle style){
		//设置第一个单元格的值

		Cell cell = row.createCell(columnFrom);
		try {
			if (val == null){
				cell.setCellValue("");
			} else if (val instanceof String) {
				cell.setCellValue((String) val);
			} else if (val instanceof Integer) {
				cell.setCellValue((Integer) val);
			} else if (val instanceof Long) {
				cell.setCellValue((Long) val);
			} else if (val instanceof Double) {
				cell.setCellValue((Double) val);
			} else if (val instanceof Float) {
				cell.setCellValue((Float) val);
			} else if (val instanceof Date) {
				DataFormat format = wb.createDataFormat();
				style.setDataFormat(format.getFormat("yyyy-MM-dd"));
				cell.setCellValue((Date) val);
			} else {
				cell.setCellValue((String)Class.forName(this.getClass().getName().replaceAll(this.getClass().getSimpleName(),
						"fieldtype."+val.getClass().getSimpleName()+"Type")).getMethod("setValue", Object.class).invoke(null, val));
			}
		} catch (Exception ex) {
			log.info("Set cell value ["+row.getRowNum()+","+columnFrom+"] error: " + ex.toString());
			cell.setCellValue(val.toString());
		}

		//合并单元格
		CellRangeAddress region = new CellRangeAddress(rowFrom,rowTo,columnFrom,columnTo);
		//Region region = new Region();
		//region.setRowFrom(rowFrom) ;
		//region.setRowTo(rowTo) ;
		//region.setColumnFrom((short)columnFrom) ;
		//region.setColumnTo((short)columnTo) ;
		sheet.addMergedRegion(region);

		//设置样式
		CellStyle cloneStyle = style;
		for(int i=rowFrom;i<=rowTo;i++){
			Row row_temp = sheet.getRow(i);
			for(int j=columnFrom;j<=columnTo;j++){
				Cell cell_temp = row_temp.getCell(j);
				if(cell_temp ==null ){
					cell_temp = row_temp.createCell(j);
				}
				cell_temp.setCellStyle(cloneStyle);
			}
		}
		return cell;


	}//addCell//

	/**
	 * 添加数据（通过annotation.ExportField添加数据）
	 * @return list 数据列表
	 */
	public <E> ExportExcel setDataList(List<E> list){
		for (E e : list){
			int colunm = 0;
			Row row = this.addRow();
			StringBuilder sb = new StringBuilder();
			for (Object[] os : annotationList){
				ExcelField ef = (ExcelField)os[0];
				Object val = null;
				// Get entity value
				try{
					if (StringUtils.isNotBlank(ef.value())){
						val = Reflections.invokeGetter(e, ef.value());
					}else{
						if (os[1] instanceof Field){
							val = Reflections.invokeGetter(e, ((Field)os[1]).getName());
						}else if (os[1] instanceof Method){
							val = Reflections.invokeMethod(e, ((Method)os[1]).getName(), new Class[] {}, new Object[] {});
						}
					}
					// If is dict, get dict label
					if (StringUtils.isNotBlank(ef.dictType())){
						val = DictUtils.getDictLabel(val == null ? "" : val.toString(), ef.dictType(), "");
					}
				}catch(Exception ex) {
					// Failure to ignore
					log.info(ex.toString());
					val = "";
				}
				this.addCell(row, colunm++, val, ef.align(), ef.fieldType());
				sb.append(val + ", ");
			}
			log.debug("Write success: ["+row.getRowNum()+"] "+sb.toString());
		}
		return this;
	}
	
	/**
	 * 输出数据流
	 * @param os 输出数据流
	 */
	public ExportExcel write(OutputStream os) throws IOException{
		wb.write(os);
		return this;
	}
	
	/**
	 * 输出到客户端
	 * @param fileName 输出文件名
	 */
	public ExportExcel write(HttpServletResponse response, String fileName) throws IOException{
		response.reset();
        response.setContentType("application/octet-stream; charset=utf-8");
        response.setHeader("Content-Disposition", "attachment; filename="+ Encodes.urlEncode(fileName));
		write(response.getOutputStream());
		return this;
	}
	
	/**
	 * 输出到文件
	 * @param name 输出文件名
	 */
	public ExportExcel writeFile(String name) throws FileNotFoundException, IOException{
		FileOutputStream os = new FileOutputStream(name);
		this.write(os);
		return this;
	}
	
	/**
	 * 清理临时文件
	 */
	public ExportExcel dispose(){
		wb.dispose();
		return this;
	}
	public ExportExcel statPoRecord(Date beginDate,Date endDate,List<PoRecord> list){
		BigDecimal totSellCost=BigDecimal.ZERO;
		BigDecimal totPNCost=BigDecimal.ZERO;
		BigDecimal totSellTax=BigDecimal.ZERO;
		BigDecimal totIncTax=BigDecimal.ZERO;
		BigDecimal totOtherTax=BigDecimal.ZERO;
		BigDecimal totMoli=BigDecimal.ZERO;
		BigDecimal totMolip=BigDecimal.ZERO;
		BigDecimal totTCost=BigDecimal.ZERO;
		BigDecimal totCmpTax=BigDecimal.ZERO;
		BigDecimal totPureEarn=BigDecimal.ZERO;
		BigDecimal totPureEarnp=BigDecimal.ZERO;
		for(PoRecord poRecord:list){
			int column = 0;
			Row row = this.addRow();
			addCell(row,column++,poRecord.getClient().getName());
			addCell(row,column++,poRecord.getPartB().getName());
			addCell(row,column++,poRecord.getSnNo());
			addCell(row,column++,poRecord.getPoNo());
			addCell(row,column++,poRecord.getSellCost());//销售金额
			totSellCost=totSellCost.add(poRecord.getSellCost());
			addCell(row,column++,poRecord.getpNCost());//采购成本
			totPNCost=totPNCost.add(poRecord.getpNCost());
			addCell(row,column++,poRecord.getSellTax());//销项税额
			totSellTax=totSellTax.add(poRecord.getSellTax());
			addCell(row,column++,poRecord.getIncTax());//进项抵税额
			totIncTax=totIncTax.add(poRecord.getIncTax());
			addCell(row,column++,poRecord.getOtherTax());//应缴税额
			totOtherTax=totOtherTax.add(poRecord.getOtherTax());
			addCell(row,column++,poRecord.getMaoli());//毛利
			totMoli=totMoli.add(poRecord.getMaoli());
			addCell(row,column++,poRecord.getMaolip()+"%");//毛利率
			addCell(row,column++,poRecord.getTotCost());//综合总成本
			totTCost=totTCost.add(poRecord.getTotCost());
			addCell(row,column++,poRecord.getCmpTax());//企业所得税
			totCmpTax=totCmpTax.add(poRecord.getCmpTax());
			addCell(row,column++,poRecord.getPureEarn());//净利润
			totPureEarn=totPureEarn.add(poRecord.getPureEarn());
			addCell(row,column++,poRecord.getPureEarnp()+"%");//净利润率
			addCell(row,column++,DictUtils.getDictLabel(poRecord.getBillType(),"bill_type",""));
		}
		totMolip=totMoli.divide(totSellCost,2,BigDecimal.ROUND_HALF_UP);
		totPureEarnp=totPureEarn.divide(totSellCost,2,BigDecimal.ROUND_HALF_UP);
		int column = 0;
		Row row = this.addRow();
		String str="";
		if(beginDate!=null){
			str+=DateUtils.formatDate(beginDate,"yyyy年MM月dd日");
			if(endDate==null){
				str+="至"+DateUtils.getDate("yyyy年MM月dd日");
			}else {
				str+="至"+DateUtils.formatDate(endDate,"yyyy年MM月dd日");
			}
		}
		addCell(row,row.getRowNum(),row.getRowNum(),0,3,"汇总:"+str,styles.get("data2"));
		addCell(row,4,totSellCost,3,Class.class);
		addCell(row,5,totPNCost,3,Class.class);
		addCell(row,6,totSellTax,3,Class.class);
		addCell(row,7,totIncTax,3,Class.class);
		addCell(row,8,totOtherTax,3,Class.class);
		addCell(row,9,totMoli,3,Class.class);
		addCell(row,10,totMolip+"%",3,Class.class);
		addCell(row,11,totTCost,3,Class.class);
		addCell(row,12,totCmpTax,3,Class.class);
		addCell(row,13,totPureEarn,3,Class.class);
		addCell(row,14,totPureEarnp+"%",3,Class.class);
		addCell(row,15,"");

		return this;
	}

	public ExportExcel statBriefPoRecord(PoRecord poRecord,boolean isDetail) {
		Row row=sheet.getRow(0);
		addCell(row,row.getRowNum(),row.getRowNum(),0,9,"PO订单数据",styles.get("title"));
		row=this.addRow();
		addCell(row,0,"甲方");
		addCell(row,row.getRowNum(),row.getRowNum(),1,4,poRecord.getClient().getName(),styles.get("data1"));
		addCell(row, 5, "订单PO号");

		addCell(row,row.getRowNum(),row.getRowNum(),6,9,poRecord.getPoNo(),styles.get("data1"));
		row=this.addRow();
		addCell(row,0,"联系人");
		addCell(row,1,poRecord.getContact());
		addCell(row,2,"联系电话");

		addCell(row,row.getRowNum(),row.getRowNum(),3,4,poRecord.getContPhone(),styles.get("data1"));
		addCell(row,5,"项目经理");
		addCell(row,6,poRecord.getPm().getName());
		addCell(row,7,"销售");
		addCell(row,row.getRowNum(),row.getRowNum(),8,9,poRecord.getSeller(),styles.get("data1"));

		row=this.addRow();
		addCell(row,0,"乙方");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),1,4));
		//addCell(row,1,"上海金曜电子工程有限公司");
		addCell(row,row.getRowNum(),row.getRowNum(),1,4,"上海金曜电子工程有限公司",styles.get("data1"));
		addCell(row,5,"归属分公司");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),6,9));
		//addCell(row,6,poRecord.getPartB().getName());
		addCell(row,row.getRowNum(),row.getRowNum(),6,9,poRecord.getPartB().getName(),styles.get("data1"));
		row=this.addRow();
		addCell(row,0,"项目名称");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),1,4));
		//addCell(row,1,poRecord.getProjectName());
		addCell(row,row.getRowNum(),row.getRowNum(),1,4,poRecord.getProjectName(),styles.get("data1"));

		addCell(row,5,"评审号");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),6,9));
		//addCell(row,6,poRecord.getSnNo());
		addCell(row,row.getRowNum(),row.getRowNum(),6,9,poRecord.getSnNo(),styles.get("data1"));
		row=this.addRow();
		addCell(row,0,"上包合同");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),1,4));
		//addCell(row,1,poRecord.getCost());
		addCell(row,row.getRowNum(),row.getRowNum(),1,4,poRecord.getCost(),styles.get("data1"));
		addCell(row,5,"发票类型");
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),6,9));
		//addCell(row,6,DictUtils.getDictLabel(poRecord.getBillType(), "bill_type", ""));
		addCell(row,row.getRowNum(),row.getRowNum(),6,9,DictUtils.getDictLabel(poRecord.getBillType(), "bill_type", ""),styles.get("data1"));

		row=this.addRow();

		int curRow=row.getRowNum();
		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),1,2));
		//addCell(row,1,"工单号");
		addCell(row,row.getRowNum(),row.getRowNum(),1,2,"工单号",styles.get("header"));

		//sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(),row.getRowNum(),3,4));
		//addCell(row,3,"站点");
		addCell(row,row.getRowNum(),row.getRowNum(),3,4,"站点",styles.get("header"));

		addCell(row,5,"WO号").setCellStyle(styles.get("header"));
		addCell(row,6,"成本").setCellStyle(styles.get("header"));
		addCell(row,7,"不含税价").setCellStyle(styles.get("header"));
		addCell(row,8,"增值税进项").setCellStyle(styles.get("header"));
		addCell(row,9,"销售金额").setCellStyle(styles.get("header"));
		int c=0;
		BigDecimal costT=BigDecimal.ZERO;
		BigDecimal outPriceT=BigDecimal.ZERO;
		BigDecimal npbT=BigDecimal.ZERO;
		BigDecimal zpbT=BigDecimal.ZERO;
		for(WoWorksheet worksheet:poRecord.getWoWorksheets()){
			Row totRow=this.addRow();
			BigDecimal cost=BigDecimal.ZERO;
			BigDecimal outPrice=BigDecimal.ZERO;
			BigDecimal npb=BigDecimal.ZERO;
			BigDecimal zpb=BigDecimal.ZERO;
			c++;
			//sheet.addMergedRegion(new CellRangeAddress(totRow.getRowNum(),totRow.getRowNum(),1,2));
			//addCell(totRow,1,worksheet.getWoNo());
			addCell(totRow,totRow.getRowNum(),totRow.getRowNum(),1,2,worksheet.getWoNo(),styles.get("data1"));
			//sheet.addMergedRegion(new CellRangeAddress(totRow.getRowNum(),totRow.getRowNum(),3,4));
			//addCell(totRow,3,worksheet.getWoStation().getName());
			addCell(totRow,totRow.getRowNum(),totRow.getRowNum(),3,4,worksheet.getWoStation().getName(),styles.get("data1"));

			addCell(totRow,5,worksheet.getSnNo());
			if(isDetail){
				c++;
				Row titleRow=this.addRow();
				addCell(titleRow,1,"材料名称").setCellStyle(styles.get("header"));
				addCell(titleRow,2,"成本单价").setCellStyle(styles.get("header"));
				addCell(titleRow,3,"数量").setCellStyle(styles.get("header"));
				addCell(titleRow,4,"成本").setCellStyle(styles.get("header"));
				addCell(titleRow,5,"票种").setCellStyle(styles.get("header"));
				addCell(titleRow,6,"不含税价").setCellStyle(styles.get("header"));
				addCell(titleRow,7,"增值税进项").setCellStyle(styles.get("header"));
				addCell(titleRow,8,"单价").setCellStyle(styles.get("header"));
				addCell(titleRow,9,"销售金额").setCellStyle(styles.get("header"));
			}
			BigDecimal cailiaoCost=BigDecimal.ZERO;
			BigDecimal cailiaonpb=BigDecimal.ZERO;
			BigDecimal cailiaozpb=BigDecimal.ZERO;
			BigDecimal cailiaooutPrice=BigDecimal.ZERO;
			for(WoFeeItem feeItem:worksheet.getCailiaoList()){
				if(isDetail){
					Row feeRow=this.addRow();
					c++;
					addCell(feeRow,1,feeItem.getName()).setCellStyle(styles.get("data1"));
					addCell(feeRow,2,feeItem.getPrice()).setCellStyle(styles.get("data1"));
					addCell(feeRow,3,feeItem.getNum()).setCellStyle(styles.get("data1"));
					addCell(feeRow,4,feeItem.getCost()).setCellStyle(styles.get("data1"));
					addCell(feeRow,5,DictUtils.getDictLabel(feeItem.getBillType(),"bill_type","")).setCellStyle(styles.get("data1"));
					addCell(feeRow,6,feeItem.getNpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,7,feeItem.getZpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,8,feeItem.getOutPer()).setCellStyle(styles.get("data1"));
					addCell(feeRow,9,feeItem.getOutPrice()).setCellStyle(styles.get("data1"));
				}
				cailiaoCost=cailiaoCost.add(feeItem.getCost());
				cailiaonpb=cailiaonpb.add(feeItem.getNpb());
				cailiaozpb=cailiaozpb.add(feeItem.getZpb());
				cailiaooutPrice=cailiaooutPrice.add(feeItem.getOutPrice());
			}
			if(isDetail){
				c++;
				Row toRow=this.addRow();
				//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),1,4));
				//addCell(toRow, 1, "材料小计").setCellStyle(styles.get("data2"));
				addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),1,3,"材料小计",styles.get("data2"));
				addCell(toRow,4,cailiaoCost.doubleValue()).setCellStyle(styles.get("data3"));
				addCell(toRow,5,"");
				addCell(toRow,6,cailiaonpb.doubleValue()).setCellStyle(styles.get("data3"));
				addCell(toRow, 7, cailiaozpb.doubleValue()).setCellStyle(styles.get("data3"));
				addCell(toRow,8,"");
				addCell(toRow,9,cailiaooutPrice.doubleValue()).setCellStyle(styles.get("data3"));
			}
			if(isDetail){
				c++;
				Row titleRow=this.addRow();
				addCell(titleRow,1,"人工说明").setCellStyle(styles.get("header"));
				addCell(titleRow,2,"成本单价").setCellStyle(styles.get("header"));
				addCell(titleRow,3,"数量").setCellStyle(styles.get("header"));
				addCell(titleRow,4,"成本").setCellStyle(styles.get("header"));
				addCell(titleRow,5,"票种").setCellStyle(styles.get("header"));
				addCell(titleRow,6,"不含税价").setCellStyle(styles.get("header"));
				addCell(titleRow,7,"增值税进项").setCellStyle(styles.get("header"));
				addCell(titleRow,8,"单价").setCellStyle(styles.get("header"));
				addCell(titleRow,9,"销售金额").setCellStyle(styles.get("header"));
			}
			BigDecimal rengongCost=BigDecimal.ZERO;
			BigDecimal rengongnpb=BigDecimal.ZERO;
			BigDecimal rengongzpb=BigDecimal.ZERO;
			BigDecimal rengongoutPrice=BigDecimal.ZERO;
			for (WoFeeItem feeItem:worksheet.getRengongList()){
				if(isDetail){
					Row feeRow=this.addRow();
					c++;
					addCell(feeRow,1,feeItem.getName()).setCellStyle(styles.get("data1"));
					addCell(feeRow, 2, feeItem.getPrice()).setCellStyle(styles.get("data1"));
					addCell(feeRow,3,feeItem.getNum()).setCellStyle(styles.get("data1"));
					addCell(feeRow,4,feeItem.getCost()).setCellStyle(styles.get("data1"));
					addCell(feeRow,5,DictUtils.getDictLabel(feeItem.getBillType(),"bill_type","")).setCellStyle(styles.get("data1"));
					addCell(feeRow,6,feeItem.getNpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,7,feeItem.getZpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,8,feeItem.getOutPer()).setCellStyle(styles.get("data1"));
					addCell(feeRow,9,feeItem.getOutPrice()).setCellStyle(styles.get("data1"));
				}
				rengongCost=rengongCost.add(feeItem.getCost());
				rengongnpb=rengongnpb.add(feeItem.getNpb());
				rengongzpb=rengongzpb.add(feeItem.getZpb());
				rengongoutPrice=rengongoutPrice.add(feeItem.getOutPrice());
			}
			if(isDetail){
				c++;
				Row toRow=this.addRow();
				//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),1,4));
				//addCell(toRow, 1, "人工小计").setCellStyle(styles.get("data2"));
				addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),1,3,"人工小计",styles.get("data2"));

				addCell(toRow,4,rengongCost.doubleValue()).setCellStyle(styles.get("data3"));

				addCell(toRow,5,"");
				addCell(toRow,6,rengongnpb.doubleValue()).setCellStyle(styles.get("data3"));
				addCell(toRow, 7, rengongzpb.doubleValue()).setCellStyle(styles.get("data3"));
				addCell(toRow,8,"");
				addCell(toRow,9,rengongoutPrice.doubleValue()).setCellStyle(styles.get("data3"));
			}
			if(isDetail){
				c++;
				Row titleRow=this.addRow();
				addCell(titleRow,1,"交通费说明").setCellStyle(styles.get("header"));
				addCell(titleRow,2,"成本单价").setCellStyle(styles.get("header"));

				addCell(titleRow,3,"数量").setCellStyle(styles.get("header"));
				addCell(titleRow,4,"成本").setCellStyle(styles.get("header"));

				addCell(titleRow,5,"票种").setCellStyle(styles.get("header"));
				addCell(titleRow,6,"不含税价").setCellStyle(styles.get("header"));
				addCell(titleRow, 7, "增值税进项").setCellStyle(styles.get("header"));
				addCell(titleRow,8,"单价").setCellStyle(styles.get("header"));
				addCell(titleRow,9,"销售金额").setCellStyle(styles.get("header"));
			}
			BigDecimal jiaotongCost=BigDecimal.ZERO;
			BigDecimal jiaotongnpb=BigDecimal.ZERO;
			BigDecimal jiaotongzpb=BigDecimal.ZERO;
			BigDecimal jiaotongoutPrice=BigDecimal.ZERO;
			for (WoFeeItem feeItem:worksheet.getQitaList()){
				if(isDetail){
					Row feeRow=this.addRow();
					c++;
					addCell(feeRow,1,feeItem.getName()).setCellStyle(styles.get("data1"));
					addCell(feeRow,2,feeItem.getPrice()).setCellStyle(styles.get("data1"));

					addCell(feeRow,3,feeItem.getNum()).setCellStyle(styles.get("data1"));
					addCell(feeRow,4,feeItem.getCost()).setCellStyle(styles.get("data1"));

					addCell(feeRow,5,DictUtils.getDictLabel(feeItem.getBillType(),"bill_type","")).setCellStyle(styles.get("data1"));
					addCell(feeRow,6,feeItem.getNpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,7,feeItem.getZpb()).setCellStyle(styles.get("data1"));
					addCell(feeRow,8,feeItem.getOutPer()).setCellStyle(styles.get("data1"));
					addCell(feeRow,9,feeItem.getOutPrice()).setCellStyle(styles.get("data1"));
				}
				jiaotongCost=jiaotongCost.add(feeItem.getCost());
				jiaotongnpb=jiaotongnpb.add(feeItem.getNpb());
				jiaotongzpb=jiaotongzpb.add(feeItem.getZpb());
				jiaotongoutPrice=jiaotongoutPrice.add(feeItem.getOutPrice());
			}
			if(isDetail){
				c++;
				Row toRow=this.addRow();
				//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),1,4));
				//addCell(toRow, 1, "交通费小计").setCellStyle(styles.get("data2"));
				addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),1,3,"交通费小计",styles.get("data2"));

				addCell(toRow,4,jiaotongCost).setCellStyle(styles.get("data3"));

				addCell(toRow,5,"");
				addCell(toRow,6,jiaotongnpb).setCellStyle(styles.get("data3"));
				addCell(toRow, 7, jiaotongzpb).setCellStyle(styles.get("data3"));
				addCell(toRow,8,"");
				addCell(toRow,9,jiaotongoutPrice).setCellStyle(styles.get("data3"));
			}
			cost=cost.add(cailiaoCost).add(rengongCost).add(jiaotongCost);
			npb=npb.add(cailiaonpb).add(rengongnpb).add(jiaotongnpb);
			zpb=zpb.add(cailiaozpb).add(rengongzpb).add(jiaotongzpb);
			outPrice=outPrice.add(cailiaooutPrice).add(rengongoutPrice).add(jiaotongoutPrice);
			addCell(totRow,6,cost.doubleValue()).setCellStyle(styles.get("data3"));
			addCell(totRow,7,npb.doubleValue()).setCellStyle(styles.get("data3"));
			addCell(totRow,8,zpb.doubleValue()).setCellStyle(styles.get("data3"));
			addCell(totRow,9,outPrice.doubleValue()).setCellStyle(styles.get("data3"));
			costT=costT.add(cost);
			npbT=npbT.add(npb);
			zpbT=zpbT.add(zpb);
			outPriceT=outPriceT.add(outPrice);
		}
		c+=2;
		Row tot=this.addRow();
		//sheet.addMergedRegion(new CellRangeAddress(tot.getRowNum(),tot.getRowNum()+1,1,5));
		//addCell(tot,1,"成本小计").setCellStyle(styles.get("data2"));


		addCell(tot,6,"成本");
		addCell(tot,7,"不计税价");
		addCell(tot,8,"增值税进项");
		addCell(tot,9,"销售金额");
		Row dat=this.addRow();
		addCell(dat,6,costT.doubleValue()).setCellStyle(styles.get("data3"));
		addCell(dat,7,npbT.doubleValue()).setCellStyle(styles.get("data3"));
		addCell(dat,8,zpbT.doubleValue()).setCellStyle(styles.get("data3"));
		addCell(dat,9,outPriceT.doubleValue()).setCellStyle(styles.get("data3"));
		addCell(tot,tot.getRowNum(),tot.getRowNum()+1,1,5,"成本小计",styles.get("data2"));
		//sheet.addMergedRegion(new CellRangeAddress(curRow,curRow+c,0,0));
		//addCell(row,0,"计划成本");
		addCell(row,curRow,curRow+c,0,0,"计划成本",styles.get("data2"));
		Row toRow=this.addRow();
		Row toRowi=toRow;
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum()+1,0,0));
		//addCell(toRow,0,"销售开票和税金");


		addCell(toRow,1,"开票金额");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),2,4));
		//addCell(toRow,2,"票种");
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),2,4,"票种",styles.get("data1"));
		addCell(toRow,5,"合同总金额");
		addCell(toRow,6,"销售金额");
		addCell(toRow,7,"销项税额");
		addCell(toRow,8,"进项抵税额");
		addCell(toRow,9,"应缴增值税");
		toRow=this.addRow();
		addCell(toRow,1,poRecord.getCost());
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),2,4));
		//addCell(toRow,2,DictUtils.getDictLabel(poRecord.getBillType(),"bill_type",""));
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),2,4,DictUtils.getDictLabel(poRecord.getBillType(),"bill_type",""),styles.get("data1"));
		addCell(toRow,5,poRecord.getCost());
		addCell(toRow,6,poRecord.getSellCost());
		addCell(toRow,7,poRecord.getSellTax());
		addCell(toRow,8,poRecord.getIncTax());
		addCell(toRow,9,poRecord.getOtherTax());
		addCell(toRowi,toRowi.getRowNum(),toRowi.getRowNum()+1,0,0,"销售开票和税金",styles.get("data1"));
		toRow=this.addRow();
		addCell(toRow,0,"毛利与毛利率预估");
		addCell(toRow,1,"税后毛利");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),2,4));
		//addCell(toRow,2,poRecord.getMaoli());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),2,4,poRecord.getMaoli(),styles.get("data1"));


		addCell(toRow,5,"税后毛利率");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),6,9));
		//addCell(toRow,6,poRecord.getMaolip());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),6,9,poRecord.getMaolip()+"%",styles.get("data1"));


		toRow=this.addRow();
		addCell(toRow,0,"综合管理费");
		addCell(toRow,1,"综合运营成本");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),2,4));
		//addCell(toRow,2,poRecord.getTotCost());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),2,4,poRecord.getTotCost(),styles.get("data1"));
		addCell(toRow,5,"企业所得税");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),6,9));
		//addCell(toRow,6,poRecord.getCmpTax());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),6,9,poRecord.getCmpTax(),styles.get("data1"));
		toRow=this.addRow();
		addCell(toRow,0,"项目净利预估");
		addCell(toRow,1,"净利润");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),2,4));
		//addCell(toRow,2,poRecord.getPureEarn());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),2,4,poRecord.getPureEarn(),styles.get("data1"));
		addCell(toRow,5,"净利润率");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),6,9));
		//addCell(toRow,6,poRecord.getPureEarnp());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),6,9,poRecord.getPureEarnp()+"%",styles.get("data1"));

		toRow=this.addRow();
		addCell(toRow,0,"备注");
		//sheet.addMergedRegion(new CellRangeAddress(toRow.getRowNum(),toRow.getRowNum(),1,9));
		//addCell(toRow,1,poRecord.getRemarks());
		addCell(toRow,toRow.getRowNum(),toRow.getRowNum(),1,9,poRecord.getRemarks(),styles.get("data1"));

		return this;
	}


//	/**
//	 * 导出测试
//	 */
//	public static void main(String[] args) throws Throwable {
//		
//		List<String> headerList = Lists.newArrayList();
//		for (int i = 1; i <= 10; i++) {
//			headerList.add("表头"+i);
//		}
//		
//		List<String> dataRowList = Lists.newArrayList();
//		for (int i = 1; i <= headerList.size(); i++) {
//			dataRowList.add("数据"+i);
//		}
//		
//		List<List<String>> dataList = Lists.newArrayList();
//		for (int i = 1; i <=1000000; i++) {
//			dataList.add(dataRowList);
//		}
//
//		ExportExcel ee = new ExportExcel("表格标题", headerList);
//		
//		for (int i = 0; i < dataList.size(); i++) {
//			Row row = ee.addRow();
//			for (int j = 0; j < dataList.get(i).size(); j++) {
//				ee.addCell(row, j, dataList.get(i).get(j));
//			}
//		}
//		
//		ee.writeFile("target/export.xlsx");
//
//		ee.dispose();
//		
//		log.debug("Export success.");
//		
//	}

}
