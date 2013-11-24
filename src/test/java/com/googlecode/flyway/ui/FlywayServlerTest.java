/**
 * Copyright (C) 2013 Benoit Prioux <benoit.prioux@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.googlecode.flyway.ui;

import com.github.kevinsawicki.http.HttpRequest;
import junit.framework.Assert;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.container.test.api.RunAsClient;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.arquillian.test.api.ArquillianResource;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.spec.WebArchive;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.net.URL;

@RunWith(Arquillian.class)
public class FlywayServlerTest {

    @Deployment
    public static WebArchive createDeployment() {
        WebArchive webArchive = ShrinkWrap.create(WebArchive.class)
                .addClass(FlywayServlet.class)
                .setWebXML("web.xml")
                .addAsWebResource("META-INF/resources/flyway.jsp", "flyway.jsp");
        return webArchive;
    }

    @Test
    @RunAsClient
    public void should_return_http_ok(@ArquillianResource URL baseURL) throws Exception {
        URL url = new URL(baseURL, "flyway");
        System.out.println("You can access to flyway UI : " + url.toString());

        int code = HttpRequest.get(url).code();
        Assert.assertEquals(code, 200);
    }
}
