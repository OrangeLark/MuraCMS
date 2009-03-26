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

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="advertiserGateway" type="any" required="yes"/>
<cfargument name="campaignManager" type="any" required="yes"/>
<cfargument name="adZoneManager" type="any" required="yes"/>
<cfargument name="creativeManager" type="any" required="yes"/>
<cfargument name="advertiserRenderer" type="any" required="yes"/>
<cfargument name="advertiserUtility" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>

	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.advertiserGateway />
	<cfset variables.instance.campaignManager=arguments.campaignManager />
	<cfset variables.instance.adZoneManager=arguments.adZoneManager />
	<cfset variables.instance.creativeManager=arguments.creativeManager />
	<cfset variables.instance.renderer=arguments.advertiserRenderer />
	<cfset variables.instance.utility=arguments.advertiserUtility />
	<cfset variables.instance.globalUtility=arguments.utility />
	<cfset variables.instance.settingsManager=arguments.settingsManager />
	
	<cfreturn this />
</cffunction>

<cffunction name="getAdvertisersBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.gateway.getAdvertisersBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="getIPWhiteListBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />

	<cfreturn variables.instance.gateway.getIPWhiteListBySiteID(variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()) />
</cffunction>

<cffunction name="updateIPWhiteListBySiteID" returntype="void" access="public" output="false">
	<cfargument name="IPWhiteList"  type="string" />
	<cfargument name="siteID"  type="string" />
	
	<cfset variables.instance.utility.updateIPWhiteListBySiteID(arguments.IPWhiteList,variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()) />
</cffunction>

<cffunction name="checkIPWhiteList" returntype="numeric" output="false" access="public">
	<cfargument name="IP" type="string" />
	<cfargument name="siteid" type="string" />

	<cfreturn variables.instance.gateway.getIPWhiteListBySiteID(arguments.id,variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()) />

</cffunction>

<cffunction name="getGroupID" returntype="string" access="public" output="false">
	<cfargument name="siteID"  type="string" />

	<cfreturn variables.instance.gateway.getGroupID(arguments.siteid) />
</cffunction>

<cffunction name="getadzonesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.adZoneManager.getadzonesBySiteID(variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID(),arguments.keywords) />
</cffunction>

<cffunction name="getCampaignsByUser" returntype="query" access="public" output="false">
	<cfargument name="userid"  type="string" />
	
	<cfreturn variables.instance.campaignManager.getCampaignsByUser(arguments.userid) />
</cffunction>

<cffunction name="getCampaignsBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteid"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfreturn variables.instance.campaignManager.getCampaignsBySiteID(variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID(),arguments.keywords) />
</cffunction>

<cffunction name="getCreativesByUser" returntype="query" access="public" output="false">
	<cfargument name="userid"  type="string" />
	
	<cfreturn variables.instance.creativeManager.getCreativesByUser(arguments.userid) />
</cffunction>

<cffunction name="getCreativesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteid"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfreturn variables.instance.creativeManager.getCreativesBySiteID(variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID(),arguments.keywords) />
</cffunction>

<cffunction name="getPlacementsByCampaign" returntype="query" access="public" output="false">
	<cfargument name="placementID"  type="string" />
	<cfargument name="date1" type="string" required="true" default="" />
	<cfargument name="date2" type="string" required="true" default="" />
	
	<cfreturn variables.instance.campaignManager.getPlacementsByCampaign(arguments.placementID,arguments.date1,arguments.date2) />
</cffunction>

<cffunction name="createAdZone" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.adZoneManager.create(arguments.data) />
</cffunction>

<cffunction name="readAdZone" returntype="any" access="public" output="false">
	<cfargument name="adZoneID"  type="string" />

	<cfreturn variables.instance.adZoneManager.read(arguments.adZoneID) />
</cffunction>

<cffunction name="updateAdZone" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.adZoneManager.update(arguments.data) />
</cffunction>

<cffunction name="deleteAdZone" returntype="void" access="public" output="false">
	<cfargument name="adZoneID"  type="string" />

	<cfreturn variables.instance.adZoneManager.delete(arguments.adZoneID) />
</cffunction>

<cffunction name="createCreative" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.CreativeManager.create(arguments.data) />
</cffunction>

<cffunction name="readCreative" returntype="any" access="public" output="false">
	<cfargument name="CreativeID"  type="string" />

	<cfreturn variables.instance.CreativeManager.read(arguments.CreativeID) />
</cffunction>

<cffunction name="updateCreative" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.CreativeManager.update(arguments.data) />
</cffunction>

<cffunction name="deleteCreative" returntype="void" access="public" output="false">
	<cfargument name="CreativeID"  type="string" />

	<cfreturn variables.instance.CreativeManager.delete(arguments.CreativeID) />
</cffunction>

<cffunction name="createCampaign" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.CampaignManager.create(arguments.data) />
</cffunction>

<cffunction name="readCampaign" returntype="any" access="public" output="false">
	<cfargument name="CampaignID"  type="string" />

	<cfreturn variables.instance.campaignManager.read(arguments.CampaignID) />
</cffunction>

<cffunction name="updateCampaign" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.campaignManager.update(arguments.data) />
</cffunction>

<cffunction name="deleteCampaign" returntype="void" access="public" output="false">
	<cfargument name="CampaignID"  type="string" />

	<cfreturn variables.instance.campaignManager.delete(arguments.CampaignID) />
</cffunction>

<cffunction name="createPlacement" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.campaignManager.createPlacement(arguments.data) />
</cffunction>

<cffunction name="readPlacement" returntype="any" access="public" output="false">
	<cfargument name="PlacementID"  type="string" />

	<cfreturn variables.instance.campaignManager.readPlacement(arguments.PlacementID) />
</cffunction>

<cffunction name="updatePlacement" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.campaignManager.updatePlacement(arguments.data) />
</cffunction>

<cffunction name="deletePlacement" returntype="void" access="public" output="false">
	<cfargument name="PlacementID"  type="string" />

	<cfreturn variables.instance.campaignManager.deletePlacement(arguments.PlacementID) />
</cffunction>

<cffunction name="getCreativeTypes" returntype="String" output="false" access="public">
<cfreturn "Banner,Content Ad,Skyscraper" />
</cffunction>

<cffunction name="getMediaTypes" returntype="String" output="false" access="public">
<cfreturn "Image,Text,Flash6,Flash7,Flash7,Flash9" />
</cffunction>

<cffunction name="readCreativeAndRender" returntype="String" output="false" access="public">
	<cfargument name="creativeID" type="string">
	<cfargument name="adZoneID" type="string" required="true" default="">
	<cfargument name="campaignID" type="string" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	
	<cfset var creativeBean=readCreative(arguments.creativeID) />
	
	<cfreturn renderCreative(creativeBean,arguments.adzoneid,arguments.campaignid,arguments.siteid) />
</cffunction>

<cffunction name="renderCreative" returntype="String" output="false" access="public">
	<cfargument name="creativeBean" type="any" />
	<cfargument name="placementID" type="string" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="track" type="numeric" required="true" default="1">
	
	<cfreturn variables.instance.renderer.renderCreative(creativeBean,arguments.placementID,arguments.siteid,arguments.track) />
</cffunction>

<cffunction name="renderAdZone" returntype="struct" output="false" access="public">
	<cfargument name="adZoneID" type="string" />
	<cfargument name="siteID" type="string" />
	<cfargument name="track" type="numeric" required="true" default="1"/>
	<cfargument name="IP" type="string" required="true" default=""/>
	
	<cfset var rs="" />
	<cfset var doTrack=arguments.track />
	<cfset var choice=0 />
	<cfset var creative="" />
	<cfset var creativeBean="" />
	<cfset var rsExclusive="" />
	<cfset var response=structNew() />
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select tadplacements.creativeid,tadplacements.placementid,isExclusive,costPerImp from 
	((((tadplacements inner join tadplacementdetails AS tdays on tadplacements.placementid=tdays.placementid)
	inner join tadplacementdetails AS thours on tadplacements.placementid=thours.placementid)
	inner join tadcreatives on tadplacements.creativeid=tadcreatives.creativeid)
	inner join tadcampaigns on tadplacements.campaignid=tadcampaigns.campaignid)
	inner join tadzones on tadplacements.adzoneid=tadzones.adzoneid
	where 
	tadzones.isActive=1
	and tadplacements.isActive=1
	and tadcampaigns.isActive=1
	and tadplacements.startDate <= #createodbcdate(now())#
	and tadplacements.endDate >= #createodbcdate(now())#
	and tadcampaigns.startDate <= #createodbcdate(now())#
	and tadcampaigns.endDate >= #createodbcdate(now())#
	and tadcreatives.isActive=1
	and tadplacements.adzoneid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adzoneID#" />
	and tdays.placementType='weekday'
	and tdays.placementValue=#dayofWeek(now())#
	and thours.placementType='hour'
	and thours.placementValue=#hour(now())#
	and tadplacements.billable < tadplacements.budget
	</cfquery>
	
	<cfquery name="rsExclusive" dbType="query">
	select * from rs where isExclusive=1
	</cfquery>
	
	<!---<cfif doTrack eq 1 and variables.instance.utility.checkIPWhiteList(arguments.ip,arguments.siteid)>
		<cfset doTrack=0 />
	</cfif>--->
	
	<cfif rsExclusive.recordcount>
			<cfset choice=randRange(1,rsExclusive.recordcount,"SHA1PRNG")>
			<cfif doTrack>
				<cfset trackAd(rsExclusive.placementID[choice],'Impression',arguments.ip,arguments.siteid,rsExclusive.costPerImp[choice]) />
			</cfif>
			<cfset creativeBean=readCreative(rsExclusive.creativeid[choice]) />
			<cfset response.mediaType=creativeBean.getMediaType() />
			<cfif left(response.mediaType,5) eq "Flash">
			<cfset response.mediaurl=variables.instance.renderer.getMediaURL(creativeBean) />
			<cfset response.height=creativeBean.getHeight() />
			<cfset response.width=creativeBean.getWidth() />
			<cfset response.redirecturl=creativeBean.getRedirectURL() />
			<cfset response.version=right(creativeBean.getMediaType(),1) />
			<cfset response.placementid=rsExclusive.placementID[choice] />
			<cfelse>
			<cfset response.creative=renderCreative(creativeBean,rsExclusive.placementID[choice],arguments.siteid,dotrack)>
			</cfif>
	<cfelseif rs.recordcount>
			<cfset choice=randRange(1,rs.recordcount,"SHA1PRNG")>
			<cfif doTrack>
				<cfset trackAd(rs.placementID[choice],'Impression',arguments.ip,arguments.siteid,rs.costPerImp[choice]) />
			</cfif>
			<cfset creativeBean=readCreative(rs.creativeid[choice]) />
			<cfset response.mediaType=creativeBean.getMediaType() />
			<cfif left(response.mediaType,5) eq "Flash">
			<cfset response.mediaurl=variables.instance.renderer.getMediaURL(creativeBean) />
			<cfset response.height=creativeBean.getHeight() />
			<cfset response.width=creativeBean.getWidth() />
			<cfset response.redirecturl=creativeBean.getRedirectURL() />
			<cfset response.version=right(creativeBean.getMediaType(),1) />
			<cfset response.placementid=rs.placementID[choice] />
			<cfelse>
			<cfset response.creative=renderCreative(creativeBean,rs.placementID[choice],arguments.siteid,dotrack)>
			</cfif>
	</cfif>
	<cfreturn response />
</cffunction>

<cffunction name="getReportDataByPlacement" returntype="void" output="false" access="public">
	<cfargument name="data" type="struct" />
	<cfargument name="PlacementBean" type="any" />
	
	<cfset variables.instance.utility.getReportDataByPlacement(arguments.data,arguments.placementBean) />	
	
</cffunction>

<cffunction name="trackAd" output="false" returntype="void">	
<cfargument name="placementID" required="true" type="string">
<cfargument name="type" required="true" type="string">
<cfargument name="ip" required="true" type="string">
<cfargument name="siteid" required="true" type="string">
<cfargument name="rate" required="true" type="numeric">

	<cfif not variables.instance.utility.checkIPWhiteList(arguments.ip,variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID())>
		<cfset variables.instance.utility.track(arguments.placementID,arguments.type,arguments.rate) />
	</cfif>
</cffunction>

<cffunction name="compact" output="false" returntype="void">	
	<cfset variables.instance.utility.compact() />
</cffunction>

</cfcomponent>