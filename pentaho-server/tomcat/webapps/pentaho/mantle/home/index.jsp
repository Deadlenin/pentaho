<%--
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License, version 2.1 as published by the Free Software
* Foundation.
*
* You should have received a copy of the GNU Lesser General Public License along with this
* program; if not, you can obtain a copy at http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
* or from the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* See the GNU Lesser General Public License for more details.
*
* Copyright (c) 2002-2013 Pentaho Corporation..  All rights reserved.
--%>

<!DOCTYPE html>
<%@page import="org.pentaho.platform.api.engine.IAuthorizationPolicy" %>
<%@page import="org.pentaho.platform.api.engine.IPluginManager" %>
<%@page import="org.pentaho.platform.engine.core.system.PentahoSessionHolder" %>
<%@page import="org.pentaho.platform.engine.core.system.PentahoSystem" %>
<%@page import="org.pentaho.platform.security.policy.rolebased.actions.AdministerSecurityAction" %>
<%@page import="org.pentaho.platform.security.policy.rolebased.actions.RepositoryReadAction" %>
<%@page import="org.pentaho.platform.security.policy.rolebased.actions.RepositoryCreateAction" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Locale" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%
    boolean canReadContent = PentahoSystem.get(IAuthorizationPolicy.class, PentahoSessionHolder.getSession())
            .isAllowed(RepositoryReadAction.NAME);
    boolean canCreateContent = PentahoSystem.get(IAuthorizationPolicy.class, PentahoSessionHolder.getSession())
            .isAllowed(RepositoryCreateAction.NAME);
    boolean canAdminister = PentahoSystem.get(IAuthorizationPolicy.class, PentahoSessionHolder.getSession())
            .isAllowed(AdministerSecurityAction.NAME);
    List<String> pluginIds =
            PentahoSystem.get(IPluginManager.class, PentahoSessionHolder.getSession()).getRegisteredPlugins();
//    Locale locale = request.getLocale();
%>
<html>
<head>
    <title>Home Page</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%--<meta name="locale" content="<%=locale.toString()%>">--%>

    <!-- Le styles -->
    <link href="css/home.css" rel="stylesheet">

    <!-- We need web context for requirejs and css -->
    <script type="text/javascript" src="webcontext.js?context=mantle&cssOnly=true"></script>
    <%
        // For consistency, we're using the same method as PentahoWebContextFilter to get scheme
        if (PentahoSystem.getApplicationContext().getFullyQualifiedServerURL().toLowerCase().startsWith("https:")) {
    %>
    <script language='JavaScript' type='text/javascript'
            src='https://sadmin.brightcove.com/js/BrightcoveExperiences.js'></script>
    <% } else { %>
    <script language='JavaScript' type='text/javascript'
            src='http://admin.brightcove.com/js/BrightcoveExperiences.js'></script>
    <% } %>


    <!-- Avoid 'console' errors in browsers that lack a console. -->
    <script type="text/javascript">
        // if(!( window.console && console.log )){
        //   ( function(){
        //     let noop = function(){
        //     };
        //     let methods = [ 'assert', 'debug', 'error', 'info', 'log', 'trace', 'warn' ];
        //     let length = methods.length;
        //     let console = window.console = {};
        //     while( length-- ){
        //       console[ methods[ length ] ] = noop;
        //     }
        //   }() );
        // }
    </script>

    <!-- Require Home -->
    <script type="text/javascript">
        let Home = null;
        require( [ "home/home",
            "common-ui/util/ContextProvider" ], function ( pentahoHome, ContextProvider ) {
            Home = pentahoHome;

            // Define properties for loading context
            let contextConfig = [
                {
                    path: "properties/config",
                    post: function ( context, loadedMap ) {
                        context.config = loadedMap;
                    }
                },
                {
                    path: "properties/messages",
                    post: function ( context, loadedMap ) {
                        context.i18n = loadedMap;
                    }
                } ];

            // Define permissions
            ContextProvider.addProperty( "canReadContent", <%=canReadContent%> );
            ContextProvider.addProperty( "canCreateContent", <%=canCreateContent%> );
            ContextProvider.addProperty( "canAdminister", <%=canAdminister%> );
            ContextProvider.addProperty( "hasAnalyzerPlugin", <%=pluginIds.contains("analyzer")%> );
            ContextProvider.addProperty( "hasIRPlugin", <%=pluginIds.contains("pentaho-interactive-reporting")%> );
            ContextProvider.addProperty( "hasDashBoardsPlugin", <%=pluginIds.contains("dashboards")%> );
            ContextProvider.addProperty( "hasMarketplacePlugin", <%=pluginIds.contains("marketplace")%> );
            ContextProvider.addProperty( "hasDataAccess", false ); // default

            // BISERVER-8631 - Manage datasources only available to roles/users with appropriate permissions
            let serviceUrl = Home.getUrlBase() + "plugin/data-access/api/permissions/hasDataAccess";
            Home.getContent( serviceUrl, function ( result ) {
                ContextProvider.addProperty( "hasDataAccess", result );
                ContextProvider.get( Home.init, contextConfig ); // initialize
            }, function ( error ) {
                console.log( error );
                ContextProvider.get( Home.init, contextConfig ); // log error and initialize anyway
            } );

        } );
    </script>
</head>

<body data-spy="scroll" data-target=".sidebar">

<div class="container-fluid main-container">
    <div class="new" id="newMainPage"></div>
    <script type="text/x-handlebars-template"></script>
    <script id="favoritesTemplate" type="text/x-handlebars-template"></script>
    <script id="recentsTemplate" type="text/x-handlebars-template" delayCompile="true"></script>


    <%--<div class='row-fluid'>--%>
    <%--<script type="text/x-handlebars-template">--%>
    <%--<div class="well sidebar">--%>
    <%--{{#if canReadContent}}--%>
    <%--<button class="btn btn-large btn-block"--%>
    <%--onclick="window.parent.mantle_setPerspective('browser.perspective')">--%>
    <%--{{i18n.browse}}--%>
    <%--</button>--%>
    <%--{{/if}}--%>

    <%--<!-- Only show create button if user is allowed -->--%>

    <%--{{#if canCreateContent}}--%>
    <%--<button id="btnCreateNew" class="btn btn-large btn-block popover-source" data-toggle="dropdown"--%>
    <%--data-toggle="popover" data-placement="right" data-html="true" data-id="my_hid"--%>
    <%--data-container="body" onclick="preCreatePopover();">--%>
    <%--{{i18n.create_new}}--%>
    <%--</button>--%>
    <%--{{/if}}--%>

    <%--{{#if hasDataAccess}}--%>
    <%--<button class="btn btn-large btn-block"--%>
    <%--onclick="window.parent.executeCommand('ManageDatasourcesCommand')">--%>
    <%--{{i18n.manage_datasources}}--%>
    <%--</button>--%>
    <%--{{/if}}--%>

    <%--<button class="btn btn-large btn-block" onclick="window.parent.executeCommand('OpenDocCommand')">--%>
    <%--{{i18n.documentation}}--%>
    <%--</button>--%>
    <%--</div>--%>

    <%--<div style="display:none" id="btnCreateNewContent"></div>--%>
    <%--</script>--%>

    <%--</div>--%>


    <%--<div class="row-fluid">--%>
    <%--<div class='span12'>--%>
    <%--<script id="recentsTemplate" type="text/x-handlebars-template" delayCompile="true">--%>
    <%--<div id="recents" class="well widget-panel">--%>
    <%--<h3>--%>
    <%--{{i18n.recents}}--%>
    <%--</h3>--%>

    <%--<div id="recentsSpinner"></div>--%>
    <%--{{#if isEmpty}}--%>
    <%--<div class="empty-panel content-panel">--%>
    <%--<div class="centered">--%>
    <%--<div class="empty-message">{{i18n.empty_recents_panel_message}}</div>--%>
    <%--<button class="pentaho-button"--%>
    <%--onclick="window.parent.mantle_setPerspective('browser.perspective');">--%>
    <%--{{i18n.browse}}--%>
    <%--</button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--{{else}}--%>
    <%--<div id="recents-content-panel" class="content-panel">--%>
    <%--<ul class="nav nav-tabs nav-stacked">--%>
    <%--{{#eachRecent recent}}--%>
    <%--<li>--%>
    <%--<a href="javascript:Home.openRepositoryFile('{{escapeQuotes fullPath}}', 'run')"--%>
    <%--title='{{title}}'>--%>
    <%--<div class="row-fluid">--%>
    <%--<div class="span10 ellipsis">--%>
    <%--{{#if xanalyzer}} <i class="pull-left content-icon file-xanalyzer"/> {{/if}}--%>
    <%--{{#if xdash}} <i class="pull-left content-icon file-xdash"/> {{/if}}--%>
    <%--{{#if xcdf}} <i class="pull-left content-icon file-xcdf"/> {{/if}}--%>
    <%--{{#if prpti}} <i class="pull-left content-icon file-prpti"/> {{/if}}--%>
    <%--{{#if ktr}} <i class="pull-left content-icon file-ktr"/> {{/if}}--%>
    <%--{{#if prpt}} <i class="pull-left content-icon file-prpt"/> {{/if}}--%>
    <%--{{#if xaction}} <i class="pull-left content-icon file-xaction"/> {{/if}}--%>
    <%--{{#if url}} <i class="pull-left content-icon file-url"/> {{/if}}--%>
    <%--{{#if html}} <i class="pull-left content-icon file-html"/> {{/if}}--%>
    <%--{{#if cda}} <i class="pull-left content-icon file-cda"/> {{/if}}--%>
    <%--{{#if wcdf}} <i class="pull-left content-icon file-wcdf"/> {{/if}}--%>
    <%--{{#if unknownType}} <i class="pull-left content-icon file-unknown"/> {{/if}}--%>
    <%--<span class="pad-left">{{title}}</span>--%>
    <%--</div>--%>
    <%--<div class="span2">--%>
    <%--{{#unless isEmpty}}--%>
    <%--{{#if isFavorite}}--%>
    <%--<i title="{{../../../i18n.remove_favorite_tooltip}}"--%>
    <%--class="pull-right favorite-on"--%>
    <%--onclick="controller.unmarkRecentAsFavorite('{{escapeQuotes fullPath}}'); return false;"/>--%>
    <%--{{else}}--%>
    <%--<i title="{{../../../i18n.add_favorite_tooltip}}"--%>
    <%--class="pull-right favorite-off"--%>
    <%--onclick="controller.markRecentAsFavorite('{{escapeQuotes fullPath}}', '{{escapeQuotes title}}'); return false;"/>--%>
    <%--{{/if}}--%>
    <%--{{/unless}}--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</a>--%>
    <%--</li>--%>
    <%--{{/eachRecent}}--%>
    <%--</ul>--%>
    <%--</div>--%>
    <%--{{/if}}--%>
    <%--</div>--%>
    <%--</script>--%>

    <%--<div id="recentsContianer"></div>--%>
    <%--</div>--%>
    <%--</div>--%>


    <%--<div class="row-fluid">--%>


    <%--<div class="span12">--%>
    <%--<script id="favoritesTemplate" type="text/x-handlebars-template" delayCompile="true">--%>
    <%--<div id="favorites" class="well widget-panel">--%>
    <%--<h3>--%>
    <%--{{i18n.favorites}}--%>
    <%--</h3>--%>

    <%--<div id="favoritesSpinner"></div>--%>
    <%--{{#if isEmpty}}--%>
    <%--<div class="empty-panel content-panel">--%>
    <%--<div class="centered">--%>
    <%--<div class="empty-message">{{i18n.empty_favorites_panel_message}}</div>--%>
    <%--<button class="pentaho-button" onclick="window.parent.mantle_setPerspective('browser.perspective')">{{i18n.browse}}</button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--{{else}}--%>
    <%--<div id="favorites-content-panel" class="content-panel">--%>
    <%--<ul class="nav nav-tabs nav-stacked">--%>
    <%--{{#eachFavorite favorites}}--%>
    <%--<li>--%>
    <%--<a href="javascript:Home.openRepositoryFile('{{escapeQuotes fullPath}}', 'run')" title='{{title}}'>--%>
    <%--<div class="row-fluid">--%>
    <%--<div class="span10 ellipsis">--%>
    <%--{{#if xanalyzer}} <i class="pull-left content-icon file-xanalyzer"/> {{/if}}--%>
    <%--{{#if xdash}} <i class="pull-left content-icon file-xdash"/> {{/if}}--%>
    <%--{{#if xcdf}} <i class="pull-left content-icon file-xcdf"/> {{/if}}--%>
    <%--{{#if prpti}} <i class="pull-left content-icon file-prpti"/> {{/if}}--%>
    <%--{{#if prpt}} <i class="pull-left content-icon file-prpt"/> {{/if}}--%>
    <%--{{#if ktr}} <i class="pull-left content-icon file-ktr"/> {{/if}}--%>
    <%--{{#if xaction}} <i class="pull-left content-icon file-xaction"/> {{/if}}--%>
    <%--{{#if url}} <i class="pull-left content-icon file-url"/> {{/if}}--%>
    <%--{{#if html}} <i class="pull-left content-icon file-html"/> {{/if}}--%>
    <%--{{#if unknownType}} <i class="pull-left content-icon file-unknown"/> {{/if}}--%>
    <%--<span class="pad-left">{{title}}</span>--%>
    <%--</div>--%>
    <%--<div class="span2">--%>
    <%--{{#unless isEmpty}}--%>
    <%--<i title="{{../../../i18n.remove_favorite_tooltip}}" class="pull-right favorite-on" onclick="controller.unmarkRecentAsFavorite('{{escapeQuotes fullPath}}'); return false;"/>--%>
    <%--{{/unless}}--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--</a>--%>
    <%--</li>--%>
    <%--{{/eachFavorite}}--%>
    <%--</ul>--%>
    <%--</div>--%>
    <%--{{/if}}--%>
    <%--</div>--%>
    <%--</script>--%>

    <%--<div id="favoritesContianer"></div>--%>

    <%--</div>--%>


    <%--</div>--%>


    <%--</div>--%>
    <%--<div class="span9" style="overflow:visible">--%>

    <%--<div class="row-fluid welcome-container">--%>

    <%--<iframe src="content/welcome/index.html" class='welcome-frame' frameborder="0" scrolling="no"></iframe>--%>

    <%--</div>--%>

    <%--</div>--%>
    <%--</div>--%>

</div>

<div id="loader" class="loader hideEl">
    Getting statuses
</div>
<button id="refreshBtn" class="refreshBtn hideEl">
    Refresh
</button>

<script charset="UTF-8" type="text/javascript">
    let tileArr = [];
    let fullNameArray = [];
    let fullNameObj = {};
    let matchedRequestCount = 0;
    let factCount = 0;
    let popup_init = false;
    let refreshBtn = document.getElementById( 'refreshBtn' );
    refreshBtn.addEventListener( 'click', refresh );
    let btnText = 'Refresh';
    let loaderText = 'Please wait...';


    function preCreatePopover() {
        if ( !popup_init ) {
            let tmp = $.fn.popover.Constructor.prototype.show;
            $.fn.popover.Constructor.prototype.show = function () {
                tmp.call( this );

                //Keep the popover from running off the screen
                let offset = 5;
                let top = this.$element.offset().top;
                let height = this.$element.outerHeight();
                let topOffset = top - offset;
                $( '.popover' ).css( 'top', topOffset + "px" );
                $( '.arrow' ).css( 'top', offset + height / 2 );

                if ( !$( '.popover-title' ).html() )
                    $( '.popover-title' ).hide();
            };
            popup_init = true;
        }
    }


    let settings = {
        url: FULL_QUALIFIED_URL + 'web-inf/web.xml',
        responseType: ''
    };
    getData( settings ).then(
        response => {
            console.dir(response);
        },
        error => console.dir( error )
    );



    function getLandingConfig() {
        let settings = {
            url: FULL_QUALIFIED_URL + 'landing-config.xml',
            responseType: ''
        };
        getData( settings ).then(
            response => {
                try {
                    let parser = new DOMParser();
                    let xmlDoc = parser.parseFromString( response, "application/xml" );
                    let node = xmlDoc.getElementsByTagName( "landing-url" ) && xmlDoc.getElementsByTagName( "landing-url" ) [ 0 ];
                    if ( node && node.getAttribute( "base-url" ) ) {
                        btnText = node.getAttribute( "btn-text" );
                        loaderText = node.getAttribute( "loader-text" );
                        let btn = document.getElementById( 'refreshBtn' );
                        let loader = document.getElementById( 'loader' );

                        btn && ( btn.textContent = btnText );
                        loader && ( loader.textContent = loaderText );
                        let url = node.getAttribute( "base-url" ) + node.getAttribute( "path" );
                        loadCompleted( url );
                    } else {
                        console.log( "check Landing Page rest api url" );
                    }

                } catch (e) {
                    console.log( e );
                }
            },
            error => console.dir( error )
        );
    }

    function getData( settings ) {
        const url = settings.url || '';
        const method = settings.method || 'GET';
        let responseType = settings.responseType !== undefined ? settings.responseType : 'json';
        const data = settings.data instanceof FormData ? settings.data : settings.data ? JSON.stringify( settings.data ) : null;
        const contentType = settings.contentType || null;
        let loader = document.getElementById( "loader" );
        if ( document.getElementsByClassName( "main-container" )[ 0 ] instanceof HTMLElement ) {
            loader.style.height = "100%";
        }
        loader && ( loader.classList.remove( "hideEl" ) );
        return new Promise( function ( resolve, reject ) {
            let xhr = new XMLHttpRequest();
            xhr.responseType = responseType;
            xhr.open( method, url, true );
            contentType && xhr.setRequestHeader( "Content-Type", contentType );
            xhr.overrideMimeType( 'text/xml' );
            xhr.onload = function () {
                if ( this.status === 200 ) {
                    loader && ( loader.classList.add( "hideEl" ) );
                    resolve( this.response );
                } else {
                    reject( this );
                    loader && ( loader.classList.add( "hideEl" ) );
                }
            };
            xhr.onerror = function ( err ) {
                loader && ( loader.classList.add( "hideEl" ) );
                reject( err );
            };
            xhr.send( data );
        } );
    }

    function refresh() {
        let content = document.getElementById( 'newMainPage' );
        content && ( content.innerHTML = "" );
        tileArr = [];
        fullNameArray = [];
        matchedRequestCount = 0;
        factCount = 0;
        let settings = {
            url: FULL_QUALIFIED_URL + 'api/repo/files/%3A/tree?depth=-1&showHidden=false&filter=*%7CFOLDERS',
            responseType: ''
        };
        getData( settings )
            .then(
                response => {
                    try {
                        let parser = new DOMParser();
                        let xmlDoc = parser.parseFromString( response, "application/xml" );
                        let page = document.getElementById( 'newMainPage' );
                        if ( page ) {
                            let tags = xmlDoc.getElementsByTagName( "file" );
                            let fLength = tags.length;
                            for (let i = 0; i < fLength; i++) {
                                //console.log(tags[ i ].getElementsByTagName( 'path' )[ 0 ].innerHTML);
                                let pathToReport = tags[ i ].getElementsByTagName( 'path' ) && tags[ i ].getElementsByTagName( 'path' )[ 0 ].innerHTML;
                                if ( pathToReport.indexOf( '/home/reports/' ) > -1 ) {
                                    let tile = createTile( pathToReport );
                                    tile.addEventListener( 'click', openRepositoryFile );
                                    page.appendChild( tile );
                                    matchedRequestCount++;
                                    tileArr.push( pathToReport );
                                }
                            }
                            if ( tileArr.length > 0 ) {
                                createRealTailData( tileArr );
                            } else {
                                //toDO no data case

                            }
                        }
                    } catch (e) {
                        console.log( e );
                    }
                },
                error => console.log( error )
            );
    }

    refresh();

    function createTile( path ) {
        let tile = document.createElement( 'div' );
        tile.classList.add( 'mainBlock' );
        tile.setAttribute( 'path', path );
        tile.setAttribute( 'title', path );
        let tileContent = document.createElement( 'div' );
        tileContent.classList.add( 'tileContent' );

        let reportStatus = document.createElement( 'div' );
        reportStatus.classList.add( 'reportStatus' );

        let reportName = document.createElement( 'div' );
        reportName.classList.add( 'tileName' );

        let reportDate = document.createElement( 'div' );
        let reportTime = document.createElement( 'div' );
        reportDate.classList.add( 'tileData' );
        reportTime.classList.add( 'tileTime' );
        tileContent.appendChild( reportStatus );
        tileContent.appendChild( reportName );
        tileContent.appendChild( reportDate );
        tileContent.appendChild( reportTime );
        tile.appendChild( tileContent );
        tile.style.display = 'none';
        return tile;
    }


    function createRealTailData( tileArr ) {
        for (let i = 0; i < tileArr.length; i++) {
            let encRep = encodeRepositoryPath( tileArr[ i ] );
            let encodePeth = encodePathComponents( encRep );
            let request = CONTEXT_PATH + "api/repo/files/" + encodePeth + "/children?showHidden=false&filter=*%7CFILES";
            $.ajax( {
                async: true,
                cache: false, // prevent IE from caching the request
                dataType: "json",
                url: request,
                success: function ( response ) {
                    if ( response ) {
                        let repositoryFileDto = response[ "repositoryFileDto" ] || null;
                        if ( repositoryFileDto ) {
                            let resultArray = [];
                            let wcdfCount = 0;
                            for (let i = 0; i < repositoryFileDto.length; i++) {
                                let reportData = repositoryFileDto[ i ];
                                if ( reportData[ "path" ].endsWith( '.prpt' ) || reportData[ "path" ].endsWith( '.wcdf' ) ) {
                                    if ( resultArray.length === 0 ) {
                                        resultArray.push( reportData );
                                        if ( reportData[ "path" ].endsWith( '.wcdf' ) ) {
                                            wcdfCount++;
                                        }
                                    } else {
                                        let pathAlreadyExist = false;
                                        let wcdfAlreadyExist = false;
                                        for (let i = 0; i < resultArray.length; i++) {
                                            if ( reportData[ "path" ] === resultArray[ i ][ "path" ] ) {
                                                pathAlreadyExist = true;
                                                break;
                                            }
                                            if ( reportData[ "path" ].endsWith( '.wcdf' ) ) {
                                                if ( ++wcdfCount > 1 ) {
                                                    break;
                                                }
                                            }
                                        }
                                        if ( !pathAlreadyExist && !wcdfAlreadyExist ) {
                                            resultArray.push( reportData );
                                        }
                                    }
                                }
                            }

                            if ( resultArray.length === 1 ) {
                                let reportData = resultArray[ 0 ];
                                let basePath = reportData[ "path" ].substring( 0, reportData[ "path" ].indexOf( reportData[ "name" ] ) - 1 );
                                let tile = document.querySelector( '[path="' + basePath + '"]' );
                                if ( tile ) {
                                    tile.setAttribute( 'path', reportData[ 'path' ] );
                                    tile.setAttribute( 'title', reportData[ 'path' ] );
                                    let reportName = reportData[ "title" ];
                                    if ( reportData[ "title" ].endsWith( '.prpt' ) || reportData[ "title" ].endsWith( '.wcdf' ) ) {
                                        reportName = reportData[ "title" ].substring( 0, reportData[ "title" ].length - 5 )
                                    }
                                    tile.getElementsByClassName( 'tileName' )[ 0 ].textContent = reportName;
                                    tile.style.display = 'inline-block';
                                    fullNameArray.push( reportData[ 'path' ] );
                                    fullNameObj[ reportData[ 'path' ] ] = reportData[ 'path' ];
                                }
                            } else {
                                let tile = null;
                                for (let i = 0; i < resultArray.length; i++) {
                                    let reportData = resultArray[ i ];
                                    let basePath = reportData[ "path" ].substring( 0, reportData[ "path" ].indexOf( reportData[ "name" ] ) - 1 );
                                    if ( !tile ) {
                                        tile = document.querySelector( '[path="' + basePath + '"]' );
                                    }
                                    if ( i === 0 ) {
                                        if ( tile ) {
                                            tile.setAttribute( 'path', reportData[ 'path' ] );
                                            tile.setAttribute( 'title', reportData[ 'path' ] );
                                            let reportName = reportData[ "title" ];
                                            if ( reportData[ "title" ].endsWith( '.prpt' ) || reportData[ "title" ].endsWith( '.wcdf' ) ) {
                                                reportName = reportData[ "title" ].substring( 0, reportData[ "title" ].length - 5 )
                                            }
                                            tile.getElementsByClassName( 'tileName' )[ 0 ].textContent = reportName;
                                            tile.style.display = 'inline-block';
                                            fullNameArray.push( reportData[ 'path' ] );
                                            fullNameObj[ reportData[ 'path' ] ] = reportData[ 'path' ];
                                        }
                                    } else {
                                        if ( tile ) {
                                            let newTile = createTile( basePath + "/" + reportData[ "name" ] );
                                            let reportName = reportData[ "title" ];
                                            if ( reportData[ "title" ].endsWith( '.prpt' ) || reportData[ "title" ].endsWith( '.wcdf' ) ) {
                                                reportName = reportData[ "title" ].substring( 0, reportData[ "title" ].length - 5 )
                                            }
                                            newTile.getElementsByClassName( 'tileName' )[ 0 ].textContent = reportName;
                                            let tileParent = tile.parentNode;
                                            newTile.style.display = 'inline-block';
                                            fullNameArray.push( reportData[ 'path' ] );
                                            fullNameObj[ reportData[ 'path' ] ] = reportData[ 'path' ];
                                            newTile.addEventListener( 'click', openRepositoryFile );
                                            tileParent.insertBefore( newTile, tile );
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if ( ++factCount === matchedRequestCount ) {
                        getLandingConfig();
                    }
                },
                error: function ( response ) {
                    if ( ++factCount === matchedRequestCount ) {
                        getLandingConfig();
                    }
                    console.log( response )
                }
            } )
        }
    }

    function xmlToJson( xml ) {
        try {
            let obj = {};
            if ( xml.children.length > 0 ) {
                for (var i = 0; i < xml.children.length; i++) {
                    let item = xml.children.item( i );
                    let nodeName = item.nodeName;
                    if ( typeof ( obj[ nodeName ] ) === "undefined" ) {
                        obj[ nodeName ] = xmlToJson( item );
                    } else {
                        if ( typeof ( obj[ nodeName ].push ) === "undefined" ) {
                            let old = obj[ nodeName ];
                            obj[ nodeName ] = [];
                            obj[ nodeName ].push( old );
                        }
                        obj[ nodeName ].push( xmlToJson( item ) );
                    }
                }
            } else {
                obj = xml.textContent;
            }
            return obj;
        } catch (e) {
            console.log( e.message );
        }
    }


    function loadCompleted( url = 'http://localhost:8090/status/oozie' ) {
        let settings = {
            url: url,
            data: null,
            method: 'POST',
        };
        getData( settings ).then( res => {
            if(refreshBtn && refreshBtn.classList.contains('hideEl')){
                refreshBtn.classList.remove('hideEl');
            }
            renderStatuses( res )
        } ).catch( err => {
            console.dir( 'error', err );
        } );
    }

    function renderStatuses( res ) {
        let foundedTails = 0;
        let matchName = 0;
        let sendingReports = fullNameArray || [];
        let notMappedReport = [];
        if ( res instanceof Array ) {
            for (let i = 0; i < sendingReports.length; i++) {
                let reportExist = false;
                let currentReport = sendingReports[ i ];
                for (let j = 0; j < res.length; j++) {
                    if ( res[ j ][ "reportName" ] === currentReport ) {
                        reportExist = true;
                        matchName++;

                        break
                    }
                }
                if ( !reportExist ) {
                    notMappedReport.push( currentReport )
                }
            }
        }
        if ( notMappedReport.length ) {
            console.log( 'not mapped report' );
            console.dir( notMappedReport );
        }
        for (let i = 0; i < res.length; i++) {
            if ( res[ i ][ "reportName" ] ) {
                let selector = "[path='" + res[ i ][ "reportName" ] + "']";
                let tail = document.querySelector( selector );
                if ( tail ) {
                    if ( res[ i ][ "jobStatusPentahoApi" ] && res[ i ][ "jobStatusPentahoApi" ][ "status" ] ) {
                        let status = res[ i ][ "jobStatusPentahoApi" ][ "status" ] && res[ i ][ "jobStatusPentahoApi" ][ "status" ].toLowerCase();
                        status && setPicture( tail, status );
                        let lastUpdate = res[ i ][ "jobStatusPentahoApi" ][ "endTime" ] || null;
                        if ( status === "succeeded" || status === "running" || status === "fail" ) {
                            if ( lastUpdate ) {
                                tail.getElementsByClassName( "tileData" )[ 0 ].textContent = res[ i ][ "reportMessage" ] + ": ";
                                tail.getElementsByClassName( "tileTime" )[ 0 ].textContent = formatDate( lastUpdate );
                            }
                        } else if ( status === "not_found" ) {
                            tail.getElementsByClassName( "tileData" )[ 0 ].textContent = res[ i ][ "reportMessage" ];
                        } else if ( status === "streaming" ) {
                        }

                    }
                    foundedTails++;
                }
            }
        }
    }

    function formatDate( t ) {
        let tm = new Date( t );
        let formatedTime = '';
        if ( tm instanceof Date ) {
            let mT = tm.getTime() + 3 * 60 * 60 * 1000;
            mT = new Date( mT );
            let y = mT.getFullYear();
            let m = pad( mT.getMonth() + 1 );
            let d = pad( mT.getUTCDate() );
            let h = pad( mT.getHours() );
            let min = pad( mT.getMinutes() );
            let sec = pad( mT.getSeconds() );
            formatedTime = `${y}/${m}/${d}  ${h}:${min}:${sec}`;
        } else {
            formatedTime = t;
        }
        return formatedTime;
    }

    function pad( d ) {
        return d < 10 ? `0${d}` : `${d}`;
    }

    function setPicture( el, status ) {
        let pictDiv = el.getElementsByClassName( "reportStatus" )[ 0 ];
        pictDiv && pictDiv.classList.add( status.toLowerCase() );
    }

    function encodeRepositoryPath( str ) {
        "use strict";
        return String( str ).replace( new RegExp( ":", "g" ), "\t" ).replace( new RegExp( "[\\\\/]", "g" ), ":" );
    }

    function openRepositoryFile( e ) {
        let path = this.nodeType && this.nodeType === 1 && this.getAttribute( 'path' );
        let mode = "run";
        if ( !path ) {
            return;
        }
        if ( !mode ) {
            mode = "edit";
        }
        let extension = path.split( "." ).pop();
        // force to open pdf files in another window due to issues with pdf readers in IE browsers
        // via class added on themeResources for IE browsers
        if ( !( $( "body" ).hasClass( "pdfReaderEmbeded" ) && extension == "pdf" ) ) {
            window.parent.mantle_setPerspective( 'opened.perspective' );
        }
        path && window.parent.mantle_openRepositoryFile( path, mode );
    }


    let encodePathComponents = function ( path ) {
        return encode( "{0}", path );
    };
    let encode = function ( str, args, queryObj ) {
        "use strict";
        if ( typeof args === "undefined" ) {
            return str;
        }
        if ( typeof args === "string" ) {
            args = [ args ];
        }
        // detect the presence of the "?" to determin when the special double-slash encoding should end
        let pathPart = str.split( "\?" )[ 0 ];
        let pathBounds = ( pathPart.match( /\{[\d]+\}/g ) || [] ).length;

        args = args.map( function ( item, pos ) {
            let encodedStr = encodeURIComponent( String( item ) )
            // double-encode / and \ to work around Tomcat issue
            if ( pos < pathBounds ) {
                encodedStr = encodedStr.replace( /%5C/g, "%255C" ).replace( /%2F/g, "%252F" );
            }
            return encodedStr;
        } );
        return args;
    };

</script>
</body>
</html>
