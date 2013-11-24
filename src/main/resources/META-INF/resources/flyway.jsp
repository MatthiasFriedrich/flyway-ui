<%@ page import="com.googlecode.flyway.core.Flyway" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.googlecode.flyway.core.api.MigrationInfoService" %>
<%@ page import="com.googlecode.flyway.core.api.MigrationInfo" %>
<html>
<head>
    <link rel="stylesheet" href="webjars/bootstrap/2.3.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 90px;
            padding-bottom: 30px;
        }
    </style>
</head>
<body>
<div class="navbar navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="brand" href="#"><img src="flyway-logo-transparent.png" alt="Flyway"></a>
            <div class="nav-collapse collapse">
                <ul class="nav">
                    <li><a href="#"><strong>Configuration</strong></a></li>
                    <li><a href="#migration"><strong>Migration</strong></a></li>
                </ul>
            </div><!--/.nav-collapse -->
        </div>
    </div>
</div>

<div class="container">
<% Flyway flyway = (Flyway) request.getAttribute("flyway"); %>
<% if (flyway == null) { %>
    <div class="alert alert-danger">
        <strong>Error :</strong> No flyway instance found !
    </div>
    <p>You should :</p>
    <ul>
        <li>define a class implementing <code>com.googlecode.flyway.ui.FlywayProvider</code></li>
        <li>add a services folder in META-INF with a file <code>/META-INF/services/com.googlecode.flyway.ui.FlywayProvider</code> containing the full name of the previous class</li>
    </ul>
<% } else { %>
    <h2 class="text-info"><a id="configuration">Configuration</a></h2>
    <table class="table table-condensed">
        <tr>
            <th>Datasource</th>
            <td>
                <%Connection connection = null;
                    try {
                        connection = flyway.getDataSource().getConnection();
                        out.print(connection.getMetaData().getURL());
                    } finally {
                        if (connection != null) {
                            connection.close();
                        }
                    }
                %>
            </td>
        </tr>
        <tr>
            <th>Encoding</th>
            <td><%=flyway.getEncoding()%></td>
        </tr>
        <tr>
            <th>Is init on migrate ?</th>
            <td>
                <% if (flyway.isInitOnMigrate()) {
                    out.print("<i class=\"icon-ok\"></i>");
                } else {
                    out.print("<i class=\"icon-remove\"></i>");
                }%>
            </td>
        </tr>
        <tr>
            <th>Is out of order ?</th>
            <td>
                <% if (flyway.isOutOfOrder()) {
                    out.print("<i class=\"icon-ok\"></i>");
                } else {
                    out.print("<i class=\"icon-remove\"></i>");
                }%>
            </td>
        </tr>
        <tr>
            <th>Is clean on validation error ?</th>
            <td>
                <% if (flyway.isCleanOnValidationError()) {
                    out.print("<i class=\"icon-ok\"></i>");
                } else {
                    out.print("<i class=\"icon-remove\"></i>");
                }%>
            </td>
        </tr>
        <tr>
            <th>Is ignored failed future migration ?</th>
            <td>
                <% if (flyway.isIgnoreFailedFutureMigration()) {
                    out.print("<i class=\"icon-ok\"></i>");
                } else {
                    out.print("<i class=\"icon-remove\"></i>");
                }%>
            </td>
        </tr>
        <tr>
            <th>Is validate on migrate ?</th>
            <td>
                <% if (flyway.isValidateOnMigrate()) {
                    out.print("<i class=\"icon-ok\"></i>");
                } else {
                    out.print("<i class=\"icon-remove\"></i>");
                }%>
            </td>
        </tr>
        <tr>
            <th>Table</th>
            <td><%=flyway.getTable()%></td>
        </tr>
        <tr>
            <th>Init description</th>
            <td><%=flyway.getInitDescription()%></td>
        </tr>
        <tr>
            <th>Sql Migration Prefix</th>
            <td><%=flyway.getSqlMigrationPrefix()%></td>
        </tr>
        <tr>
            <th>Sql Migration Suffix</th>
            <td><%=flyway.getSqlMigrationSuffix()%></td>
        </tr>
        <tr>
            <th>Locations</th>
            <td>
                <%String[] locations = flyway.getLocations();
                    for (String location : locations) {
                        out.println(location);
                    }
                %>
            </td>
        </tr>
        <tr>
            <th>Schemas</th>
            <td>
                <%String[] schemas = flyway.getSchemas();
                    for (String schema : schemas) {
                        out.println(schema);
                    }
                %>
            </td>
        </tr>
        <tr>
            <th>Placeholder Prefix</th>
            <td><%=flyway.getPlaceholderPrefix()%></td>
        </tr>
        <tr>
            <th>Placeholder Suffix</th>
            <td><%=flyway.getPlaceholderSuffix()%></td>
        </tr>
        <tr>
            <th>Placeholder</th>
            <td>
                <%Map<String, String> placeholders = flyway.getPlaceholders();
                    for (Map.Entry<String, String> placeholder : placeholders.entrySet()) {
                        out.println("key:" + placeholder.getKey() + ", value:" + placeholder.getValue());
                    }
                %>
            </td>
        </tr>
    </table>

    <h2 class="text-info"><a id="migration">Migration</a></h2>
    <% MigrationInfo[] info = flyway.info().all(); %>
    <table class="table table-condensed">
        <tr>
            <th>Version</th>
            <th>Description</th>
            <th>Type</th>
            <th>Script</th>
            <th>State</th>
            <th>Date</th>
            <th>Execution Time</th>
            <th>Checksum</th>
        </tr>
        <% for (int i=0; i<info.length; i++) { %>
        <tr>
            <td><%=info[i].getVersion()%></td>
            <td><%=info[i].getDescription()%></td>
            <td><%=info[i].getType()%></td>
            <td><%=info[i].getScript()%></td>
            <td><%=info[i].getState().getDisplayName()%></td>
            <td><%=info[i].getInstalledOn()%></td>
            <td><%=info[i].getExecutionTime()%></td>
            <td><%=info[i].getChecksum()%></td>
        </tr>
        <% }%>
     </table>
    <%} %>
</div> <!-- /container -->

</body>
</html>
