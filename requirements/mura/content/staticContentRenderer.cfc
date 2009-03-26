<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="contentRenderer"  output="false">

<cffunction name="createHREF" returntype="string" output="false" access="public">
	<cfargument name="type" required="true">
	<cfargument name="filename" required="true">
	<cfargument name="siteid" required="true">
	<cfargument name="contentid" required="true">
	<cfargument name="target" required="true" default="">
	<cfargument name="targetParams" required="true" default="">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="context" type="string" default="">
	<cfargument name="stub" type="string" default="">
	<cfargument name="indexFile" type="string"  default="index.htm">
	<cfargument name="complete" type="boolean"  default="false">
	
	<cfset var href=""/>
	<cfset var tp=""/>
	<cfset var begin=iif(arguments.complete,de('http://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'),de('')) />
	<cfset var staticIndexFile = "index.htm">
	<cfset var contentBean = "">
	<cfset var rsFile = "">
	
		<cfswitch expression="#arguments.type#">
				<cfcase value="Link,File">
					<cfset contentBean=application.contentManager.getActiveContent(arguments.contentID,arguments.siteid) />
					<cfset rsFile=application.serviceFactory.getBean('fileManager').read(contentBean.getfileid()) />
					<cfset href="/#application.settingsManager.getSite(arguments.siteid).getExportLocation()#/#replace(arguments.contentid, '-', '', 'ALL')#.#rsfile.fileExt#"/>
				</cfcase>
				<cfdefaultcase>
					<cfset href="/#application.settingsManager.getSite(arguments.siteid).getExportLocation()#/#arguments.filename##iif(arguments.filename neq '',de('/'),de(''))##staticIndexFile#" />
				</cfdefaultcase>
		</cfswitch>
		
		<cfif arguments.target eq "_blank">
			<cfset tp=iif(arguments.targetParams neq "",de(",'#arguments.targetParams#'"),de("")) />
			<cfset href="javascript:newWin=window.open('#href#','NewWin#replace('#rand()#','.','')#'#tp#);newWin.focus();void(0);" />
		</cfif>

<cfreturn href />
</cffunction>

<cffunction name="addlink" output="false" returntype="string">
			<cfargument name="type" required="true">
			<cfargument name="filename" required="true">
			<cfargument name="title" required="true">
			<cfargument name="target" type="string"  default="">
			<cfargument name="targetParams" type="string"  default="">
			<cfargument name="contentid" required="true">
			<cfargument name="siteid" required="true">
			<cfargument name="querystring" type="string"  default="">
			<cfargument name="context" type="string"  default="">
			<cfargument name="stub" type="string"  default="">
			<cfargument name="indexFile" type="string"  default="index.cfm">
			
			<cfset var link ="">
			<cfset var href ="">
			<cfset var staticIndexFile = "index.htm">
			
			<cfif request.contentBean.getcontentid() eq arguments.contentid>
				<cfset link='<a href="#staticIndexFile#" class="current">#arguments.title#</a>' /> 
			<cfelse>
				<cfset href=createHREF(arguments.type,arguments.filename,arguments.siteid,arguments.contentid,arguments.target,iif(arguments.filename eq request.contentBean.getfilename(),de(''),de(arguments.targetParams)),arguments.queryString,arguments.context,arguments.stub,arguments.indexFile)>
				<cfset link='<a href="#href#" #iif(request.contentBean.getparentid() eq arguments.contentid,de("class=current"),de(""))#>#arguments.title#</a>' />
			</cfif>

		<cfreturn link>
</cffunction>

</cfcomponent>