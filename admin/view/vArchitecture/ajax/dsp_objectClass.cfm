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

<cfswitch expression="#attributes.classid#">
<cfcase value="component">
<cfoutput>
<cfset request.rsUserDefinedTemplates=application.contentManager.getComponents("00000000000000000000000000000000000",attributes.siteid) />
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsUserDefinedTemplates">
	<option value="Component~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.component')# - #request.rsUserDefinedTemplates.menutitle#~#request.rsUserDefinedTemplates.contentid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.component')# - #request.rsUserDefinedTemplates.menutitle#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="mailingList">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsmailinglists=application.contentUtility.getMailingLists(attributes.siteid) />
<option value="mailing_list_master~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mastermailinglistsignupform')#~none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mastermailinglistsignupform')#</option>
<cfloop query="request.rsmailinglists">
	<option value="mailing_list~Mailing List - #request.rsmailinglists.name#~#request.rsmailinglists.mlid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglist')# - #request.rsmailinglists.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="system">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsObjects=application.contentManager.getSystemObjects(attributes.siteid) />
<cfloop query="request.rsObjects">
	<option value="#request.rsobjects.object#~#request.rsObjects.name#~none">#request.rsObjects.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="form">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsForms=application.contentManager.getComponentType(attributes.siteid,'Form') />
<cfloop query="request.rsForms">
	<option value="form~#iif(request.rsForms.responseChart eq 1,de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.poll')#'),de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datacollector')#'))# - #request.rsForms.menutitle#~#request.rsForms.contentid#">#iif(request.rsForms.responseChart eq 1,de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.poll')#'),de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datacollector')#'))# - #request.rsForms.menutitle#</option>
	<cfif request.rsForms.responseChart neq 1><option value="form_responses~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.dataresponses')# - #request.rsForms.menutitle#~#request.rsForms.contentid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.dataresponses')# - #request.rsForms.menutitle#</option></cfif>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="adzone">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsAdZones=application.advertiserManager.getadzonesBySiteID(attributes.siteid,'') />
<cfloop query="request.rsAdZones">
	<option value="adZone~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adzone')# - #request.rsAdZones.name#~#request.rsAdZones.adZoneID#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adzone')# - #request.rsAdZones.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<!--- <cfcase value="category">
<cfset request.rsSections=application.contentManager.getSections(attributes.siteid) />
<cfset request.rsCategories=application.categoryManager.getCategoriesBySiteID(attributes.siteid,'') />
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','category',this.value);" class="dropdown">
<option value="" <cfif attributes.subclassid eq ''>selected</cfif>>Across All Site Sections</option> 
<cfloop query="request.rsSections">
	<cfif attributes.subclassid eq request.rsSections.contentID>
	<cfset selected ='selected'>
	<cfset currentSection = request.rsSections.currentRow />
	<cfelse>
	<cfset selected =''>
	</cfif>
	<option value="#request.rsSections.contentid#" #selected#>#HTMLEditFormat(request.rsSections.menutitle)# - #request.rsSections.type#</option> 
	
	</cfloop>
</select><br/>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsCategories">
	<cfif attributes.subclassid eq ''>
	<option value="category_features~Featured #request.rsCategories.name# Category Content [Summaries]~#request.rsCategories.categoryid#">Featured #request.rsCategories.name# Category Content [Summaries]</option>
	<option value="category_features_no_summary~Featured #request.rsCategories.name# Category Content~#request.rsCategories.categoryid#">Featured #request.rsCategories.name# Category Content </option>
	<cfelse>
	<option value="category_portal_features~#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# [Summaries]~#request.rsCategories.categoryid#,#request.rsSections.contentid[currentSection]#">#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# [Summaries]</option>
	<option value="category_portal_features_no_summary~#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# Portal~#request.rsCategories.categoryid#,#request.rsSections.contentid[currentSection]#">#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]#</option>			
	</cfif>
</cfloop>
</select>
</cfcase> --->
<cfcase value="portal">
<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Portal') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','portal',this.value);" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectportal')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<!--- <option value="features~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]</option>
	<option value="features_no_summary~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content</option> --->
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')# [RSS]~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	<option value="calendar_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#</option>
	</cfif>
</cfloop>
</select>
</cfif>
</cfoutput>
</cfcase>
<cfcase value="calendar">

<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Calendar') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','calendar',this.value);" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcalendar')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<option value="features~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontentsummaries')#</option>
	<option value="features_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontent')#</option>
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	</cfif>
</cfloop>
</select>
</cfif>

</cfoutput>
</cfcase>
<cfcase value="gallery">

<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Gallery') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','gallery',this.value);" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectgallery')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<!--- <option value="features~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]</option>
	<option value="features_no_summary~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content</option> --->
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')# Summary~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	<option value="calendar_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#</option>
	</cfif>
</cfloop>
</select>
</cfif>
</cfoutput>
</cfcase>

<cfcase value="localFeed">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rslist=application.feedManager.getFeeds(attributes.siteid,'Local') />
<option value="feed_table~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexlistingtable')#~none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexlistingtable')#</option>
<cfloop query="request.rslist">
	<option value="feed~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexsummaries')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexsummaries')#</option>
	<option value="feed_no_summary~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="remoteFeed">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rslist=application.feedManager.getFeeds(attributes.siteid,'Remote') />
<cfloop query="request.rslist">
	<option value="feed~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeedsummaries')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeedsummaries')#</option>
	<option value="feed_no_summary~#request.rslist.name# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>

<cfcase value="plugins">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
</cfoutput>
<cfset request.rslist=application.pluginManager.getDisplayObjectBySiteID(attributes.siteid) />
<cfoutput query="request.rslist" group="moduleID">
	<cfif application.permUtility.getModulePerm(request.rslist.moduleID,attributes.siteid)>
	<optgroup label="#htmlEditFormat(request.rslist.title)#">
	<cfoutput>	
	<option value="plugin~#request.rslist.title# - #request.rslist.name#~#request.rslist.objectID#">#request.rslist.name#</option>
	</cfoutput>
	</optgroup>
	</cfif>
</cfoutput>
<cfoutput></select></cfoutput>
</cfcase>

</cfswitch>

<cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##attributes.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_objectClass.cfm")> 
	<cfinclude template="/#application.configBean.getWebRootMap()#/#attributes.siteID#/includes/display_objects/custom/admin/dsp_objectClass.cfm" >
</cfif>