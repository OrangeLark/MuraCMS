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
<cfhtmlhead text="#session.dateKey#">
<cfparam name="request.rsPublicGroups.recordcount" default="0" />
<cfparam name="attributes.direction" default="">
<cfparam name="attributes.orderBy" default="">
<cfparam name="attributes.page" default="1">
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,"email.emailmanager")#</h2></cfoutput>
<cfsilent>
	  <cfset startDate=createDate(year(now()),month(now()),1)>
	  <cfset stopDate=createDate(year(now()),month(now()),day(now()))>
	  <cfset emailLimit = application.settingsManager.getSite(attributes.siteID).getEmailBroadcasterLimit()>
	  <cfset emailsSent = application.emailManager.getSentCount(attributes.siteID, startDate,stopDate)>
	  <cfif emailLimit eq 0>
	  	<cfset emailLimitText = "Unlimited">
		<cfset emailsRemainingText = "Unlimited">
	  <cfelse>
	  	<cfset emailLimitText = emailLimit>
		<cfset emailsRemainingText = emailLimit - emailsSent>
	  </cfif></cfsilent>   
	  <cfoutput>
	  <ul class="metadata"><li>#application.rbFactory.getKeyValue(session.rb,"email.emailssent")#: <strong>#emailsSent# (#LSDateFormat(startDate,session.dateKeyFormat)# - #LSDateFormat(stopDate, session.dateKeyFormat)#)</strong></li>
	  <li>#application.rbFactory.getKeyValue(session.rb,"email.emailsalloted")#: <strong>#emailLimitText#</strong></li>
	  <li>#application.rbFactory.getKeyValue(session.rb,"email.emailsremaining")#: <strong>#emailsRemainingText#</strong></li></ul>
	  </cfoutput>
	  <!---<div id="bounces" class="divide">
	  <h3>Bounces</h3>
	  <a href="index.cfm?fuseaction=cEmail.showAllBounces&siteid=<cfoutput>#attributes.siteid#</cfoutput>">View All Bounces</a>
	  </div>--->
	  <cfoutput>
<ul id="navTask"><li><a href="index.cfm?fuseaction=cEmail.edit&emailid=&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,"email.addemail")#</a></li></ul>

	  <div id="filterView" >
	  <h3>#application.rbFactory.getKeyValue(session.rb,"email.emails")#</h3></cfoutput>
<form action="index.cfm?fuseaction=cEmail.list&siteid=<cfoutput>#attributes.siteid#</cfoutput>" method="post" name="form1" id="advancedSearch" class="clearfix">
<dl class="filter">
<dt><cfoutput>#application.rbFactory.getKeyValue(session.rb,"email.filterby")#:</dt>
<dd><select name="groupID">
      	<optgroup label="#application.rbFactory.getKeyValue(session.rb,'email.all')#">
		<option value="">#application.rbFactory.getKeyValue(session.rb,"email.all")#</option>
		</optgroup></cfoutput>
		<option value=""></option>
		<cfif request.rsPrivateGroups.recordcount>
			<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.privategroups')#</cfoutput>">
				<cfoutput query="request.rsPrivateGroups">
					<option value="#request.rsPrivateGroups.UserID#" <cfif listfind(session.emaillist.groupid,request.rsPrivateGroups.userid)>selected</cfif>>#request.rsPrivateGroups.groupname#</option>
		  		</cfoutput>
			</optgroup>
		    <option value=""></option>
		</cfif>
		<cfif request.rsPublicGroups.recordcount>
			<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.publicgroups')#</cfoutput>">
				<cfoutput query="request.rsPublicGroups">
					<option value="#request.rsPublicGroups.UserID#" <cfif  listfind(session.emaillist.groupid,request.rsPublicGroups.userid)>selected</cfif>>#request.rsPublicGroups.groupname#</option>
				</cfoutput>
			</optgroup>
			<option value=""></option>
		</cfif>
		<cfif request.rsMailingLists.recordcount>
			<optgroup label="<cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.mailinglist')#</cfoutput>">
				<cfoutput query="request.rsMailingLists">
				<option value="#request.rsMailingLists.mlid#" <cfif  listfind(session.emaillist.groupid,request.rsMailingLists.mlid)>selected</cfif>>#request.rsMailingLists.name#</option>
				</cfoutput>
			</optgroup>
			<option value=""></option>
		</cfif>
	  </select>
</dd>
</dl><cfoutput>
<dl class="status">
<dt>#application.rbFactory.getKeyValue(session.rb,'email.status')#</dt>
<dd><input type="radio"  name="status" value="2"  <cfif session.emaillist.status eq 2>checked</cfif>> <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.all')#</span> <input type="radio"  name="status" value="1" <cfif session.emaillist.status eq 1>checked</cfif>> <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.sent')#</span> <input type="radio"  name="status" value="0"  <cfif session.emaillist.status eq 0>checked</cfif>> <span class="text">#application.rbFactory.getKeyValue(session.rb,'email.queued')#</span></dd>
</dl>
<dl class="subject">
 <dt>#application.rbFactory.getKeyValue(session.rb,'email.subject')# <span>(#application.rbFactory.getKeyValue(session.rb,'email.leaveblanktoviewall')#)</span></dt>
 <dd><input type="text"  name="subject" value="#session.emaillist.subject#" class="textbox"></dd>
</dl>
<input type="hidden" name="doSearch" value="true"/>			  
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,'email.filter')#</span></a>
</form>
</div>
</cfoutput>
	  <table id="metadata" class="stripe">
        <tr> 
		  <cfset subjectDirection = "asc">
		  <cfset createdDateDirection = "desc">
		  <cfset deliveryDateDirection = "desc">
		  <cfset statusDirection = "asc">
		  <cfswitch expression="#attributes.orderBy#">
		  	<cfcase value="subject">
				 <cfif attributes.direction eq "asc">
				 	<cfset subjectDirection = "desc">
				</cfif>
			</cfcase>
			<cfcase value="createdDate">
				<cfif attributes.direction eq "desc">
					<cfset createdDateDirection = "asc">
				</cfif>
			</cfcase>
			<cfcase value="deliveryDate">
				<cfif attributes.direction eq "desc">
					<cfset deliveryDateDirection = "asc">
				</cfif>
			</cfcase>
			<cfcase value="status">
				<cfif attributes.direction eq "asc">
					<cfset statusDirection = "desc">
				</cfif>
			</cfcase>
		  </cfswitch>
		  <cfoutput>
		  <th class="varWidth"><a href="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#&orderBy=subject&direction=#subjectDirection#">#application.rbFactory.getKeyValue(session.rb,'email.subject')#</a></th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.clicks')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.opens')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.bounces')#</th>
		  <th>#application.rbFactory.getKeyValue(session.rb,'email.all')#</th>
		  <th><a href="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#&orderBy=createdDate&direction=#createdDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.datecreated')#</a></th>
          <th><a href="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#&orderBy=deliveryDate&direction=#deliveryDateDirection#">#application.rbFactory.getKeyValue(session.rb,'email.deliverydate')#</a></th>
          <th><a href="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#&orderBy=status&direction=#statusDirection#">#application.rbFactory.getKeyValue(session.rb,'email.status')#</a></th>
          <th>&nbsp;</th>
		  </cfoutput>
        </tr>
		<cfset recordsPerPage = 20>
        <cfif request.rslist.recordcount>
          <cfif isNumeric(attributes.page)>
		  	<cfset startRow = ((attributes.page-1) * recordsPerPage) + 1>
		  <cfelse>
		  	<cfset startRow = 1>
		  </cfif>
		  <cfset endRow = startRow + (recordsPerPage - 1)>
		  <cfoutput>
			  <cfloop query="request.rslist" startRow="#startRow#" endRow="#endRow#"> 
				  <cfset clicks=application.emailManager.getStat(request.rslist.emailid,'returnClick')/>
				  <cfset opens=application.emailManager.getStat(request.rslist.emailid,'emailOpen')/>
				  <cfset sent=application.emailManager.getStat(request.rslist.emailid,'sent')/>
				  <cfset bounces=application.emailManager.getStat(request.rslist.emailid,'bounce')/>
					<tr> 
					  <td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cEmail.edit&emailid=#request.rslist.emailid#&siteid=#attributes.siteid#">#request.rslist.subject#</a></td>
					  <td>#clicks#</td>
					  <td>#opens#</td>
					  <td>#bounces#</td>
					  <td>#sent#</td>
					  <td>#LSDateFormat(request.rslist.createddate,session.dateKeyFormat)#</td>
					  <td><cfif LSisDate(request.rslist.deliverydate)>#LSDateFormat(request.rslist.deliverydate,session.dateKeyFormat)# #LSTimeFormat(request.rslist.deliverydate,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
					  <td><cfif LSisDate(request.rslist.deliverydate)><cfif request.rslist.status eq 99>In Progress<cfelseif request.rslist.status eq 1>#application.rbFactory.getKeyValue(session.rb,'email.sent')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'email.queued')#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,'email.notscheduled')#</cfif></td>
					  <td class="administration"><ul class="three"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'email.edit')#" href="index.cfm?fuseaction=cEmail.edit&emailid=#request.rslist.emailid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'email.edit')#</a></li><li class="download"><a title="#application.rbFactory.getKeyValue(session.rb,'email.download')#" href="index.cfm?fuseaction=cEmail.download&emailID=#request.rsList.emailID#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'email.download')#</a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'email.delete')#" href="index.cfm?fuseaction=cEmail.update&action=delete&emailid=#request.rslist.emailid#&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'email.deleteconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'email.delete')#</a></li></ul></td>
					</tr>
			  </cfloop>
		  
		  </cfoutput>
        <cfelse>
          <tr> 
            <td colspan="9" nowrap class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'email.noemails')#</cfoutput></td>
          </tr>
        </cfif>
      </table>
	  <cfoutput>
	  <cfif request.rslist.recordcount gt recordsPerPage>
		#application.rbFactory.getKeyValue(session.rb,'email.moreresults')#: 
		<cfloop from="1" to="#Ceiling(request.rslist.recordcount/recordsPerPage)#" index="i">
			<cfif i eq attributes.page>
				#i#
			<cfelse>
				<a href="index.cfm?fuseaction=cEmail.list&siteid=#attributes.siteid#&page=#i#&direction=#attributes.direction#&orderBy=#attributes.orderBy#">#i#</a>
			</cfif>
		</cfloop> 
	  </cfif>
	  </cfoutput>