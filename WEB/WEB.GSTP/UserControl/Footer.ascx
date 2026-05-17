<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Footer.ascx.cs" Inherits="WEB.GSTP.UserControl.Footer" %>
<div class="footer">
    <div style="float:left;width:68%;padding: 3px 0px;text-align:center;">
          Bản quyền thuộc Tòa án nhân dân tối cao
    </div>
   <div style="float:right;width:30%;padding: 3px 0px;text-align:right;padding-right:10px;">
         
          Số người online: <b><asp:Literal ID="lstOnline" runat="server"></asp:Literal> </b>&nbsp;&nbsp;&nbsp; 
       Lượt truy cập: <b><asp:Literal ID="lstLuottruycap" runat="server"></asp:Literal></b>
    </div>
</div>
