
package org.androidpn.server.xmpp.auth;


import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.androidpn.server.service.UserNotFoundException;
import org.androidpn.server.xmpp.UnauthenticatedException;
import org.apache.commons.codec.binary.Hex;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * This class is to provide the methods associated with user authentication. 
 *
 * @author Sehwan Noh (devnoh@gmail.com)
 */
public class AuthManager {

    private static Logger logger= LoggerFactory.getLogger(AuthManager.class);

    private static final Object DIGEST_LOCK = new Object();

    private static MessageDigest digest;

    static {
        try {
            digest = MessageDigest.getInstance("SHA");
        } catch (NoSuchAlgorithmException e) {
            logger.error("Internal server error", e);
        }
    }

    /**
     * Returns the user's password. 
     *
     * @param username the username
     * @return the user's password
     * @throws UserNotFoundException if the your was not found
     */
    public static String getPassword(String username)
            throws UserNotFoundException {
        return UserUtils.getByLoginName(username)
                .getPassword();
    }



    /**
     * Authenticates a user with a username and plain text password, and
     * returns an AuthToken.
     *
     * @param username the username
     * @param password the password
     * @return an AuthToken
     * @throws UnauthenticatedException if the username and password do not match
     */
    public static AuthToken authenticate(String username, String password)
            throws UnauthenticatedException {
        if (username == null || password == null) {
            throw new UnauthenticatedException();
        }
        logger.info("androidpn 验证：username="+username+",password="+password);
        //username = username.trim().toLowerCase();
        username = username.trim();
        if (username.contains("@")) {
            int index = username.indexOf("@");
            String domain = username.substring(index + 1);
           // if (domain.equals(XmppServer.getInstance().getServerName())) {
                username = username.substring(0, index);
//            } else {
//                throw new UnauthenticatedException();
//            }
        }
        try {
            String pwd= SystemService.entryptPassword(password);
            String afterpwd = getPassword(username);
            logger.info("username="+username+"Pwd="+pwd+" afterpwd="+afterpwd);
//            if (SystemService.validatePassword(password,afterpwd)) {
//                System.out.println("===========登陆失败=validatePassword=============");
//                throw new UnauthenticatedException();
//            }
        } catch (UserNotFoundException unfe) {
            System.out.println("===========登陆失败=UserNotFoundException=============");
            throw new UnauthenticatedException();

        }
        System.out.println("===========登陆成功==============");
        AuthToken token = new AuthToken(username);
        System.out.println("===========>>token.name="+token.getUsername()+" token.domain="+token.getDomain());
        return token;
    }

    /**
     * Authenticates a user with a username, token, and digest, and returns
     * an AuthToken.
     *
     * @param username the username
     * @param token the token
     * @param digest the digest
     * @return an AuthToken
     * @throws UnauthenticatedException if the username and password do not match 
     */
    public static AuthToken authenticate(String username, String token,
                                         String digest) throws UnauthenticatedException {
        if (username == null || token == null || digest == null) {
            throw new UnauthenticatedException();
        }
        //username = username.trim().toLowerCase();
        username = username.trim();
        if (username.contains("@")) {
            int index = username.indexOf("@");
            String domain = username.substring(index + 1);
            //if (domain.equals(XmppServer.getInstance().getServerName())) {
                username = username.substring(0, index);
            //} else {
            //    throw new UnauthenticatedException();
            //}
        }
        try {
            String password = getPassword(username);
            String anticipatedDigest = createDigest(token, password);
            if (!digest.equalsIgnoreCase(anticipatedDigest)) {
                throw new UnauthenticatedException();
            }
        } catch (UserNotFoundException unfe) {
            throw new UnauthenticatedException();
        }
        System.out.println("===========登陆成功2==============");
        return new AuthToken(username);
    }

    /**
     * Returns true if plain text password authentication is supported according to JEP-0078.
     *
     * @return true if plain text password authentication is supported
     */
    public static boolean isPlainSupported() {
        return true;
    }

    /**
     * Returns true if digest authentication is supported according to JEP-0078.
     *
     * @return true if digest authentication is supported
     */

    public static boolean isDigestSupported() {
        return false;
    }

    private static String createDigest(String token, String password) {
        synchronized (DIGEST_LOCK) {
            digest.update(token.getBytes());
            return Hex.encodeHexString(digest.digest(password.getBytes()));
        }
    }

}
