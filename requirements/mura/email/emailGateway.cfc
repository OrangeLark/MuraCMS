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
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="configBean" type="any" required="yes"/>
				<cfset variables.configBean=arguments.configBean />
				<cfset variables.dsn=variables.configBean.getDatasource()/>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPrivateGroups" access="public" output="false" returntype="query">
		<cfargument name="siteid" type="string" />
	
		<cfset var rsPrivateGroups = "" />
	
			<cfquery name="rsPrivateGroups" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select userid, groupname, ispublic from tusers where type =1 and ispublic=0
			and 
			userid in (select groupid from tpermissions where contentid='00000000000000000000000000000000000' and siteid='#application.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#')
			order by groupname
			</cfquery>
		
		<cfreturn rsPrivateGroups />
		
	</cffunction>
	
	<cffunction name="getPublicGroups" access="public" output="false" returntype="query">
		<cfargument name="siteid" type="string" />
		<cfset var rs ="" />
		<cfquery name="rs"  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select * from tusers where ispublic=1 and type=1 and siteid='#application.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'  order by groupname
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getMailingLists" access="public" output="false" returntype="query">
		<cfargument name="siteid" type="string" />
		<cfset var rs ="" />
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select * from tmailinglist where ispurge=0 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> order by name
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getList" access="public" output="false" returntype="query" >
		<cfargument name="args" type="struct" />
		
		<cfset var rs ="" />
		<cfset var g ="" />
		<cfset var data=arguments.args />
		<cfset var counter =0 />
		
		
		<cfparam name="session.emaillist.status" default=2>
		<cfparam name="session.emaillist.groupid" default="">
		<cfparam name="session.emaillist.subject" default="">
		<cfparam name="session.emaillist.dontshow" default=0>
		<cfparam name="session.emaillist.orderBy" default="temails.CreatedDate desc, temails.subject">
		<cfparam name="session.emaillist.direction" default="">
		
		<cfif isdefined('data.doSearch')>
			<cfset session.emaillist.status=data.status>
			<cfset session.emaillist.groupid=data.groupid>
			<cfset session.emaillist.subject=data.subject>
			<cfset session.emaillist.dontshow=0>
		<cfelse>
			<cfset session.emaillist.groupid="">
		</cfif>
		<cfif isDefined('data.orderBy') and data.orderBy neq "">
			<cfset session.emaillist.orderBy = data.orderBy>
		</cfif>
		<cfif isDefined('data.direction') and data.direction neq "">
			<cfset session.emaillist.direction = data.direction>
		</cfif>
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select temails.emailid, subject, status, createddate, deliverydate, lastupdatebyid, numbersent
			from temails
			where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.siteID#" />
			
			<cfif not session.emaillist.dontshow>
				<cfif listlen(session.emaillist.groupid)>
					<cfset counter=0>
						
						<cfloop list="#session.emaillist.groupid#" index="g">
								<cfset counter=counter+1>
								<cfif counter eq 1>and (<cfelse>or</cfif> 
								grouplist like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#g#%" />
						</cfloop>
						<cfif counter>)</cfif>
				</cfif>
			<cfelse>
			
			and 0=1
			
			</cfif>
		
		
		 
			<cfif  session.emaillist.status lt 2 or session.emaillist.subject neq ''>
				<cfif session.emaillist.status lt 2>
					 and  temails.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.emaillist.status#" />
				</cfif>
				<cfif session.emaillist.subject neq ''>
					and temails.subject like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.emaillist.subject#%" />
				</cfif>
			</cfif>
			
			and isDeleted = 0
			
			ORDER BY #session.emaillist.orderBy# #session.emaillist.direction#
		</cfquery>
	
		<cfreturn rs />
	
	</cffunction>
	
	<cffunction name="getStat" output="false" returntype="numeric" access="public">
	<cfargument name="emailid" type="string">
		<cfargument name="type" type="string">
	
		<cfset var rs=""/>
		<cfset var returnVar=0/>
		
		<cfif arguments.type eq "returnClick" or arguments.type eq "emailOpen" or arguments.type eq "sent" or arguments.type eq "bounce">
			<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				select count(#arguments.type#) as stat from temailstats
				where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
				and #arguments.type# = 1
			</cfquery>
			<cfset returnVar = rs.stat>
		<cfelseif arguments.type eq "returnUnique">
			<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				select distinct(url)from temailreturnstats
				where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
			</cfquery>
			<cfset returnVar = rs.recordCount>
		<cfelseif arguments.type eq "returnAll">	
			<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				select count(emailID) as stat from temailreturnstats
				where emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
			</cfquery>
			<cfset returnVar = rs.stat>
		</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getBounces" output="false" returntype="any" access="public">
		<cfargument name="emailid" type="string">
	
		<cfset var rs=""/>
		 
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			SELECT count(email) as bounceCount, email  
			from temailstats where 
			emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" /> and bounce = 1
			group by email
			order by bounceCount desc
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getAllBounces" output="false" returntype="any" access="public">
		<cfargument name="data" type="struct">
	
		<cfset var rs=""/>
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			SELECT count(email) as bounceCount, email  
			from temails
			inner join temailstats on temails.emailid = temailstats.emailid
			where temails.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.siteID#" /> and temailstats.bounce = 1
			group by email
			<cfif isDefined('arguments.data.bounceFilter') and arguments.data.bounceFilter neq "">
				having (bounceCount >= #int(arguments.data.bounceFilter)#)
			</cfif>
			order by bounceCount desc
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getReturns" output="false" returntype="any" access="public">
		<cfargument name="emailid" type="string">
	
		<cfset var rs=""/>
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			SELECT count(url) as returnCount, url 
			from temailreturnstats where 
			emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" /> group by url 
			order by returnCount desc
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getReturnsByUser" output="false" returntype="any" access="public">
		<cfargument name="emailid" type="string">
	
		<cfset var rs=""/>
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			SELECT distinct(email)
			from temailreturnstats where 
			emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#" />
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getSentCount" output="false" returntype="any" access="public">
		<cfargument name="siteid" type="string">
		<cfargument name="startDate" type="string" default="#dateAdd('d',-30,now())#">
		<cfargument name="stopDate" type="string">
	
		<cfset var returnVar=""/>
		<cfset var rs=""/>
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			SELECT COUNT(temails.EmailID) AS emailCount
			FROM temails INNER JOIN
			temailstats ON temails.EmailID = temailstats.EmailID
			WHERE (temails.siteid = '#arguments.siteid#')
			and temailstats.created <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#
			and temailstats.created >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#
		</cfquery>

		<cfset returnVar = rs.emailCount>
		
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="deleteBounces" output="false" returntype="void" access="public">
		<cfargument name="data" type="struct">
	
		<cfset var rs=""/>
		<cfset var i = "">
		
		<cfloop from="1" to="#listLen(arguments.data.bouncedEmail)#" index="i">
			<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				DELETE FROM tmailinglistmembers WHERE email IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.data.bouncedEmail,i)#" />)
			</cfquery>
		</cfloop>

	</cffunction>

	<cffunction name="getEmailActivity" access="public" output="false" returntype="query" >
		<cfargument name="siteid" type="string" />
		<cfargument name="limit" type="numeric" required="true" default="3">
		<cfargument name="startDate" type="string" required="true" default="">
		<cfargument name="stopDate" type="string" required="true" default="">
		
		<cfset var rs ="" />
		<cfset var stop ="" />
		<cfset var start ="" />
		<cfset var dbType=variables.configBean.getDbType() />
		
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			<cfif dbType eq "oracle">select * from (</cfif>
			select <cfif dbType eq "mssql">Top #arguments.limit#</cfif>
			temails.emailid, subject, status, createddate, deliverydate, lastupdatebyid, numbersent
			from temails
			where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
			and isDeleted=0
			
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and deliveryDate >= #createodbcdatetime(createdatetime(year(start),month(start),day(start),0,0,0))#
		<cfcatch>
		and deliveryDate >= #createodbcdatetime(createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and deliveryDate <= #createodbcdatetime(createdatetime(year(stop),month(stop),day(stop),23,59,0))#
		<cfcatch>
		and deliveryDate <= #createodbcdatetime(createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#
		</cfcatch>
		</cftry>
	</cfif>
			order by deliveryDate desc
			
			<cfif dbType eq "mysql">limit #arguments.limit#</cfif>
			<cfif dbType eq "oracle">) where ROWNUM <=#arguments.limit# </cfif>
		</cfquery>
	
		<cfreturn rs />
	
	</cffunction>
</cfcomponent>