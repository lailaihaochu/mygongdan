package com.jinbang.gongdan.modules.sys.service;

import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.androidpn.server.model.User;
import org.androidpn.server.service.UserExistsException;
import org.androidpn.server.service.UserNotFoundException;
import org.androidpn.server.service.UserService;
import org.androidpn.server.xmpp.session.ClientSession;
import org.androidpn.server.xmpp.session.SessionManager;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by haoyaogang_1 on 2016/9/11.
 */
public class AndroidUserServiceImpl implements UserService {
    protected SessionManager sessionManager;

    public AndroidUserServiceImpl(){
        sessionManager = SessionManager.getInstance();
    }

    @Override
    public User getUser(String s) {
        return null;
    }

    @Override
    public List<User> getUsers() {
        Collection<ClientSession> sessions = sessionManager.getSessions();
        List<User> list = new ArrayList<User>();
        return list;
    }

    @Override
    public User saveUser(User user) throws UserExistsException {
        return null;
    }

    @Override
    public User getUserByUsername(String username) throws UserNotFoundException {
   // System.out.println("+++++++++++=getUserByUsername===============");
        User user = new User();
        user.setUsername(username);
        user.setPassword(UserUtils.getByLoginName(username).getPassword());
        System.out.println("username="+username +" password="+user.getPassword());
        return user;
    }


    @Override
    public void removeUser(Long aLong) {

    }

//    public List<Map<String,String>> getUserInfo(){
//        Collection<ClientSession> sessions = SessionManager.getInstance().getSessions();
//        List<Map<String,String>> list = new ArrayList<Map<String,String>>();
//        Map<String,String> u = null;
//        for(ClientSession s : sessions){
//            if(s.getAuthToken()==null)continue;
//            u = new HashMap<String,String>();
//            try {
//                @SuppressWarnings("unchecked")
//                List<UserGroup> groups = ((List<UserGroup>)s.getSessionData("groups"));
//                if(groups!=null&&groups.size()>0){
//                    String gname  = "";
//                    for(UserGroup ug : groups){
//                        gname += ug.getSGroupName()+",";
//                    }
//                    if(gname.length()>0){
//                        gname = gname.substring(0, gname.length()-1);
//                    }
//                    u.put("ugroup", gname);
//                }else{
//                    u.put("ugroup", "");
//                }
//                u.put("username", s.getUsername());
//                u.put("ip", s.getHostName());
//                u.put("id", s.getStreamID());
//                list.add(u);
//            } catch (UserNotFoundException e) {
//                // TODO Auto-generated catch block
//                e.printStackTrace();
//            } catch (UnknownHostException e) {
//                // TODO Auto-generated catch block
//                e.printStackTrace();
//            }
//        }
//        return list;
//    }
}
