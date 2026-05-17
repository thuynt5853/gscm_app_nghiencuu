<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuLeft.ascx.cs" Inherits="WEB.GSTP.UserControl.MenuLeft" %>
<div class="left_body">
    <div class="headerleft">
        <asp:Literal ID="lstChuongTrinh" runat="server"></asp:Literal>
    </div>
   <div id="divTreeMenuLeft" style="float: left;padding-top:10px; background: #fcfdfd; margin-bottom: 20px;overflow:auto;overflow-x: hidden;">
            <asp:Literal ID="lstMess" runat="server"></asp:Literal>
            <asp:TreeView ID="tvOne" runat="server" Width="232px" NodeWrap="True" NodeIndent="7"  ShowLines="false" EnableClientScript="False" OnSelectedNodeChanged="tvOne_SelectedNodeChanged" >
                <NodeStyle  ImageUrl="/UI/img/folder.gif" HorizontalPadding="3" Width="100%" ForeColor="#222222"  Font-Size="14px"
                Font-Names="Arial,Helvetica,sans-serif"    VerticalPadding="5px" />
                <ParentNodeStyle ImageUrl="/UI/img/root.gif"  Font-Size="14px" ForeColor="#003317"  />
                <RootNodeStyle ImageUrl="/UI/img/root.gif"  Font-Size="14px" ForeColor="#003317" />
                <SelectedNodeStyle    Font-Size="14px" Font-Bold="true" ForeColor="#e3393c" BackColor="#f5f5f5" />
                <DataBindings>
                    <asp:TreeNodeBinding DataMember="menuitem"  TextField="Text"   ToolTipField="Text"  ValueField="ID" NavigateUrlField="NavigateUrl" />
                </DataBindings>
            </asp:TreeView>
        </div>
</div>
<asp:HiddenField ID="hddMenuCount" runat="server" Value="0" />
<asp:Literal ID="lblError" runat="server"></asp:Literal>

