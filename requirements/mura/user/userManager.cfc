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
<cfargument name="userDAO" type="any" required="yes"/>
<cfargument name="userGateway" type="any" required="yes"/>
<cfargument name="userUtility" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="fileManager" type="any" required="yes"/>
<cfargument name="pluginManager" type="any" required="yes"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.userDAO=arguments.userDAO />
	<cfset variables.userGateway=arguments.userGateway />
	<cfset variables.userUtility=arguments.userUtility />	
	<cfset variables.globalUtility=arguments.utility />
	<cfset variables.ClassExtensionManager=variables.configBean.getClassExtensionManager() />
	<cfset variables.fileManager=arguments.fileManager />
	<cfset variables.pluginManager=arguments.pluginManager />
	
<cfreturn this />
</cffunction>

<cffunction name="getUserGroups" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string" default=""/>
		<cfargument name="isPublic" type="numeric" default="0"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.userGateway.getUserGroups(arguments.siteid,arguments.isPublic) />
		
		<cfreturn rs />
	</cffunction>
	
<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="userid" type="string" default=""/>		
	<cfreturn variables.userDAO.read(arguments.userid) />
</cffunction>

<cffunction name="readUserHash" access="public" returntype="query" output="false">
	<cfargument name="userid" type="string" default=""/>		
	<cfreturn variables.userDAO.readUserHash(arguments.userid) />
</cffunction>

<cffunction name="readByUsername" access="public" returntype="any" output="false">
	<cfargument name="username" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>		
	<cfreturn variables.userDAO.readByUsername(arguments.username,arguments.siteid) />
</cffunction>

<cffunction name="readByRemoteID" access="public" returntype="any" output="false">
	<cfargument name="remoteID" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>		
	<cfreturn variables.userDAO.readByRemoteID(arguments.remoteID,arguments.siteid) />
</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>	
	<cfargument name="updateGroups" type="boolean" default="true" required="yes" />
	<cfargument name="updateInterests" type="boolean" default="true" required="yes" />
	<cfargument name="OriginID" type="string" default="" required="yes" />
	
	<cfset var error =""/>
	<cfset var addressBean =""/>
	<cfset var userBean=variables.userDAO.read(arguments.data.userid) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
				
	<cfset userBean.set(arguments.data) />

	<!--- <cfif userBean.getType() eq 2 and  userBean.getAddressID() neq ''> --->
	<cfif userBean.getAddressID() neq ''>
	<cfset addressBean=variables.userDAO.readAddress(userBean.getAddressID()) />
	<cfset addressBean.set(arguments.data) />
	</cfif>

	<cfif isDefined('arguments.data.activationNotify') and userBean.getInActive() eq 0>	
		<cfset variables.userUtility.sendActivationNotification(userBean) />
	</cfif>
	
	<cfif structIsEmpty(userBean.getErrors())>
	
		<cfif structKeyExists(arguments.data,"extendSetID")>
			<cfset arguments.data.siteID=userBean.getSiteID() />
			<cfset variables.ClassExtensionManager.saveExtendedData(userBean.getUserID(),arguments.data,'tclassextenddatauseractivity')/>
		</cfif>
		
		<cfif structKeyExists(arguments.data,"newFile") and len(arguments.data.newfile)>
			<cfset setPhotoFile(userBean)/>
		</cfif>

		<cfif isDefined('arguments.data.removePhotoFile') and arguments.data.removePhotoFile eq "true" and len(userBean.getPhotoFileID())>
			<cfset variables.fileManager.deleteVersion(userBean.getPhotoFileID()) />
			<cfset userBean.setPhotoFileID("") />
		</cfif>
		
		<cfif userBean.getAddressID() neq ''>
		<cfset variables.userDAO.updateAddress(addressBean) />
		</cfif>
		
		<cfset variables.globalUtility.logEvent("UserID:#userBean.getUserID()# Type:#userBean.getType()# User:#userBean.getFName()# #userBean.getFName()# Group:#userBean.getGroupName()# was updated","sava-users","Information",true) />
		<cfset setLastUpdateInfo(userBean) />
		<cfset variables.userDAO.update(userBean,arguments.updateGroups,arguments.updateInterests,arguments.OriginID) />
	
		<cfif  userBean.getType() eq 1>	
			<cfset pluginEvent.setValue("groupBean",userBean)/>			
			<cfset variables.pluginManager.executeScripts("onGroupUpdate",userBean.getSiteID(),pluginEvent)>	
		<cfelse>
			<cfset pluginEvent.setValue("userBean",userBean)/>	
			<cfset variables.pluginManager.executeScripts("onUserUpdate",userBean.getSiteID(),pluginEvent)>	
		</cfif>
		
	</cfif>
	
	<cfreturn userBean />
</cffunction>

<cffunction name="create" access="public" returntype="struct" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var addressBean = "" />
	<cfset var userBean=application.serviceFactory.getBean("userBean") />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	
	<cfset userBean.set(arguments.data) />
	<cfset userBean.setUserID(createuuid()) />
	
	<!--- <cfif userBean.getType() eq 2> --->
	<cfset addressBean=application.serviceFactory.getBean("addressBean") />
	<cfset addressBean.set(arguments.data) />
	<cfset addressBean.setAddressID(createuuid()) />
	<cfset addressBean.setUserID(userBean.getUserID()) />
	<cfset addressBean.setIsPrimary(1) />
	<cfset addressBean.setAddressName('Primary') />
	<!--- </cfif> --->
	
	<cfif userBean.getPassword() eq ''>
	<cfset userBean.setPassword(variables.userUtility.getRandomPassword(6,"Alpha","no"))/>
	</cfif>
	
	<cfif structIsEmpty(userBean.getErrors())>
		
		<cfif structKeyExists(arguments.data,"extendSetID")>
			<cfset arguments.data.siteID=userBean.getSiteID() />
			<cfset variables.ClassExtensionManager.saveExtendedData(userBean.getUserID(),arguments.data,'tclassextenddatauseractivity')/>
		</cfif>
		
		<cfif structKeyExists(arguments.data,"newFile") and len(arguments.data.newfile)>
			<cfset setPhotoFile(userBean)/>
		</cfif>
		
		<cfif structIsEmpty(userBean.getErrors())>
		<cfset variables.globalUtility.logEvent("UserID:#userBean.getUserID()# Type:#userBean.getType()# User:#userBean.getFName()# #userBean.getFName()# Group:#userBean.getGroupName()# was created","sava-users","Information",true) />
		<cfset setLastUpdateInfo(userBean) />
		<cfset variables.userDAO.create(userBean) />
		<cfset variables.userDAO.createAddress(addressBean) />
		</cfif>
	
		<cfif  userBean.getType() eq 1>	
			<cfset pluginEvent.setValue("groupBean",userBean)/>			
			<cfset variables.pluginManager.executeScripts("onGroupCreate",userBean.getSiteID(),pluginEvent)>	
		<cfelse>
			<cfset pluginEvent.setValue("userBean",userBean)/>	
			<cfset variables.pluginManager.executeScripts("onUserCreate",userBean.getSiteID(),pluginEvent)>	
		</cfif>
	</cfif>
	
	<cfreturn userBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="userid" type="string" default=""/>
	<cfargument name="type" type="numeric" default="2"/>
	
	<cfset var userBean=read(arguments.userid) />
	<cfset var pluginEvent = createObject("component","mura.event") />
	
	<cfif  userBean.getType() eq 1>	
		<cfset pluginEvent.setValue("groupBean",userBean)/>			
		<cfset variables.pluginManager.executeScripts("onGroupDelete",userBean.getSiteID(),pluginEvent)>	
	<cfelse>
		<cfset pluginEvent.setValue("userBean",userBean)/>	
		<cfset variables.pluginManager.executeScripts("onUserDelete",userBean.getSiteID(),pluginEvent)>	
	</cfif>
	
	<cfset variables.globalUtility.logEvent("UserID:#arguments.userid# Type:#userBean.getType()# User:#userBean.getFName()# #userBean.getFName()# Group:#userBean.getGroupName()# was deleted","sava-users","Information",true) />
	<cfif len(userBean.getPhotoFileID())>
		<cfset variables.fileManager.deleteVersion(userBean.getPhotoFileID()) />
	</cfif>
	<cfset variables.userDAO.delete(arguments.userid,arguments.type) />
	
</cffunction>

<cffunction name="readGroupMemberships" access="public" returntype="any" output="false">
	<cfargument name="userid" type="string" default="" required="yes"/>		
	<cfreturn variables.userDAO.readGroupMemberships(arguments.userid) />
</cffunction>

<cffunction name="readInterestGroups" access="public" returntype="any" output="false">
	<cfargument name="userid" type="string" default="" required="yes"/>		
	<cfreturn variables.userDAO.readInterestGroups(arguments.userid) />
</cffunction>

<cffunction name="readMemberships" access="public" returntype="any" output="false">
	<cfargument name="userid" type="string" default="" required="yes"/>		
	<cfreturn variables.userDAO.readMemberships(arguments.userid) />
</cffunction>

<cffunction name="getPublicGroups" access="public" returntype="any" output="false">
	<cfargument name="siteid" type="string" default="" required="yes"/>		
	<cfreturn variables.userGateway.getPublicGroups(arguments.siteid) />
</cffunction>

<cffunction name="getPrivateGroups" access="public" returntype="any" output="false">
	<cfargument name="siteid" type="string" default="" required="yes"/>	
	<cfreturn variables.userGateway.getPrivateGroups(arguments.siteid) />
</cffunction>

<cffunction name="createUserInGroup" access="public" returntype="void" output="false">
	<cfargument name="userid" type="string" default="" required="yes"/>		
	<cfargument name="groupid" type="string" default="" required="yes"/>
	<cfset variables.userDAO.createUserInGroup(arguments.userid,arguments.groupid) />
</cffunction>

<cffunction name="deleteUserFromGroup" access="public" returntype="void" output="false">
	<cfargument name="userid" type="string" default="" required="yes"/>		
	<cfargument name="groupid" type="string" default="" required="yes"/>
	<cfset variables.userDAO.deleteUserFromGroup(arguments.userid,arguments.groupid) />
</cffunction>

<cffunction name="getSearch" access="public" returntype="query" output="false">
	<cfargument name="search" type="string" default="" required="yes"/>		
	<cfargument name="siteid" type="string" default="" required="yes"/>
	<cfargument name="isPublic" type="numeric" default="1" required="yes"/>
	<cfreturn variables.userGateway.getSearch(arguments.search,arguments.siteid,arguments.isPublic) />
</cffunction>

<cffunction name="getAdvancedSearch" access="public" returntype="query" output="false">
	<cfargument name="data" type="any" default="" required="yes"/>		
	<cfargument name="siteid" type="string" default="" required="yes"/>
	<cfargument name="isPublic" type="numeric" default="1" required="yes"/>
	<cfreturn variables.userGateway.getAdvancedSearch(arguments.data,arguments.siteid,arguments.isPublic) />
</cffunction>

<cffunction name="setLastUpdateInfo" access="public" returntype="void" output="false">
	<cfargument name="userBean" type="any" default="" required="yes"/>		
	<cfif getAuthUser() neq "" >
			<cfset arguments.userBean.setLastUpdateBy(listGetAt(getAUthUser(),"2","^"))/>
			<cfset arguments.userBean.setLastUpdateByID(listFirst(getAuthUser(),"^"))/>
		<cfelse>
			<cfset arguments.userBean.setLastUpdateBy("#arguments.userBean.getFname()# #arguments.userBean.getlname()#")/>
			<cfset arguments.userBean.setLastUpdateByID(arguments.userBean.getUserID())/>
		</cfif>
</cffunction>

<cffunction name="sendLoginByEmail" access="public" returntype="string" output="false">
		<cfargument name="email" type="string" default=""/>
		<cfargument name="siteid" type="string" default=""/>
		<cfargument name="returnURL" type="string" default=""/>
	
		<cfreturn variables.userUtility.sendLoginByEmail(arguments.email,arguments.siteid,arguments.returnURL) />
		
</cffunction>

<cffunction name="sendLoginByUser" access="public" returntype="string" output="false">
		<cfargument name="userBean" type="any"/>
		<cfargument name="siteid" type="string" default=""/>
		<cfargument name="returnURL" type="string" default=""/>
		<cfargument name="isPublicReg" required="yes" type="boolean" default="false"/>
	
		<cfreturn variables.userUtility.sendLoginByUser(arguments.userBean,arguments.siteid,arguments.returnURL,arguments.isPublicReg) />
		
</cffunction>

<cffunction name="createAddress" access="public" returntype="struct" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var addressBean=application.serviceFactory.getBean("addressBean") />
	
	<cfset addressBean.set(arguments.data) />
	<cfset addressBean.setAddressID(createuuid()) />
	
	
	
	<cfif structIsEmpty(addressBean.getErrors())>
		<cfset variables.userDAO.createAddress(addressBean) />
	</cfif>
	
	<cfreturn addressBean />
</cffunction>

<cffunction name="updateAddress" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>	
	
	<cfset var error =""/>
	<cfset var addressBean=variables.userDAO.readAddress(arguments.data.addressid) />
	<cfset addressBean.set(arguments.data) />
	
	<cfif structIsEmpty(addressBean.getErrors())>
		<cfset variables.userDAO.updateAddress(addressBean) />
	</cfif>
	
	<cfreturn addressBean />
</cffunction>

<cffunction name="deleteAddress" access="public" returntype="void" output="false">
	<cfargument name="addressid" type="string" default=""/>			
	
	<cfset variables.userDAO.deleteAddress(arguments.addressid) />
	
</cffunction>

<cffunction name="getCurrentUserID" access="public" returntype="string" output="false">		
	
	<cfreturn listFirst(getAuthUser(),'^') />
	
</cffunction>

<cffunction name="getCurrentName" access="public" returntype="string" output="false">		
	
	<cftry>
		<cfreturn listGetAt(getAuthUser(),2,'^') />
		<cfcatch>
			<cfreturn ''/>
		</cfcatch>
	</cftry>
	
</cffunction>

<cffunction name="getCurrentLastLogin" access="public" returntype="string" output="false">		
	
	<cftry>
		<cfreturn listGetAt(getAuthUser(),3,'^') />
		<cfcatch>
			<cfreturn ''/>
		</cfcatch>
	</cftry>
	
</cffunction>

<cffunction name="getCurrentCompany" access="public" returntype="string" output="false">		
	
	<cftry>
		<cfreturn listGetAt(getAuthUser(),4,'^') />
		<cfcatch>
			<cfreturn ''/>
		</cfcatch>
	</cftry>
	
</cffunction>

<cffunction name="setPhotoFile" output="false">
<cfargument name="userBean" />

<cfset var theFileStruct=structNew() />
<cfset var error=structNew() />

<cffile action="upload" filefield="NewFile" nameconflict="makeunique" destination="#getTempDirectory()#">

<cfif (file.ServerFileExt eq "jpg" or file.ServerFileExt eq "gif" or file.ServerFileExt eq "png") and file.ContentType eq "Image">
	<cftry>
		<cfif len(arguments.userBean.getPhotoFileID())>
			<cfset variables.fileManager.deleteVersion(arguments.userBean.getPhotoFileID()) />
		</cfif>
		<cfset theFileStruct=variables.fileManager.process(file,arguments.userBean.getSiteID()) />
		<cfset arguments.userBean.setPhotoFileID(variables.fileManager.create(theFileStruct.fileObj,arguments.userBean.getUserID(),arguments.userBean.getSiteID(),file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,'00000000000000000000000000000000008',file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium)) />
		<cfcatch>
			<cfset error.photo="The file you uploaded appears to be corrupt. Please select another file to upload."/>
			<cfset userBean.setErrors(error)/> 
		</cfcatch>
	</cftry>
<cfelse>
	<cffile action="delete" file="#getTempDirectory()##file.serverfile#">
	<cfset error.photo="The file you uploaded is not a supported format. Only, JPEG, GIF and PNG files are accepted."/>
	<cfset userBean.setErrors(error)/> 
</cfif>
</cffunction>

</cfcomponent>