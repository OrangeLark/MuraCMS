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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cMailingList.list&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.Edit&mlid=#attributes.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.editmailinglist')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.download&mlid=#attributes.mlid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.downloadmembers')#</a></li>
</ul>

<form action="index.cfm?fuseaction=cMailingList.updatemember" name="form1" method="post" onsubmit="return validate(this);">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.email')#</dt>
<dd><input type=text name="email" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emailrequired')#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.firstname')#</dt>
<dd><input type=text name="fname" class="text" /></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.lastname')#</dt>
<dd><input type=text name="lname" class="text" /></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#</dt>
<dd><input type=text name="company" class="text" /></dd>
<dt><input type="radio" name="action" id="a" value="add" checked> <label id="a">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.subscribe')#</label> <input type="radio" id="d" name="action" value="delete"> <label for="d">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.unsubscribe')#</label></dt>
</dl>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.submit')#</span></a>
<input type=hidden name="mlid" value="#attributes.mlid#">
<input type=hidden name="siteid" value="#attributes.siteid#">
<input type=hidden name="isVerified" value="1">
</form>
<h3>#request.listBean.getname()#</h3>

<table id="metadata" class="stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.emails')# (#request.rslist.recordcount#)</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.company')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.verified')#</th>
	<th>&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist" startrow="#attributes.startrow#" maxrows="#request.nextN.RecordsPerPage#">
	<tr>
		<td class="varWidth"><a href="mailto:#HTMLEditFormat(email)#">#HTMLEditFormat(email)#</a></td>
		<td>#HTMLEditFormat(fname)#&nbsp;#HTMLEditFormat(lname)#</td>
		<td>#HTMLEditFormat(company)#</td>
		<td><cfif isVerified eq 1>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.yes')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.no')#</cfif></td>
		<td class="administration"><ul class="mailingListMembers"><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#" href="index.cfm?fuseaction=cMailingList.updatemember&action=delete&mlid=#request.rslist.mlid#&email=#urlencodedformat(request.rslist.email)#&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deletememberconfirm'))#');">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</a></li></ul></td></tr>
</cfoutput>
<cfelse>
<tr>
<td class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.nomembers')#</cfoutput></td>
</tr>
</cfif>
</table>
<cfinclude template="dsp_list_members_next_n.cfm">