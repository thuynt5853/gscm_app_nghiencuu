<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Phanquyen.aspx.cs" Inherits="WEB.GSTP.QTCucTHA.Nhomnguoidung.Phanquyen" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="box">
        <div class="tle" style="background:none;border-bottom:none;">
            <p class="texttle" style="text-align:left;margin-left:20px;text-transform:none;color:#ba0505;font-weight:bold;">
                > Phân quyên cho nhóm:
            <asp:Literal ID="lstName" runat="server"></asp:Literal>
            </p>
        </div>
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Lựa chọn các quyền, quền tối thiểu để hiện chức năng là quyền xem</h4>
                <div class="truong">
                    <table class="table1">
                        <tr >
                            <td align="left" style="display:none;width: 250px; border-right: 1px solid #CCCCCC; vertical-align: top;">
                                <asp:TreeView ID="treemenu" NodeWrap="True" runat="server" ShowLines="True" OnSelectedNodeChanged="treemenu_SelectedNodeChanged">
                                    <NodeStyle ImageUrl="../../UI/img/folder.gif" HorizontalPadding="3" Width="100%" CssClass="tree_menu"
                                        VerticalPadding="3px" />
                                    <ParentNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <RootNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <SelectedNodeStyle Font-Bold="True" />
                                </asp:TreeView>
                            </td>
                            <td align="left" style="vertical-align: top;">
                                <table class="table1" style="width:80%">

                                    <tr style="display:none;">
                                        <td align="left">
                                            <asp:Button ID="cmdUpdate" runat="server" Visible="false" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />


                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <b style="color: red;">
                                                <asp:Literal ID="lstMess" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:CheckBox ID="chkAuto" Checked="true" runat="server" Font-Italic="true" Text="Tự động chọn chức năng con khi chọn chức năng cha" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:DataGrid ID="dgMenu" runat="server" AutoGenerateColumns="False" AllowPaging="false" Visible="false"
                                                PagerStyle-Font-Bold="True" BorderColor="#C4C4CF" BorderStyle="Solid" Width="100%"
                                                BorderWidth="1px" BackColor="White" CellPadding="2"
                                                CellSpacing="0">
                                                <FooterStyle ForeColor="#002266" BackColor="#E9F0FA"></FooterStyle>
                                                <PagerStyle Font-Bold="True"></PagerStyle>
                                                <SelectedItemStyle Font-Bold="True" ForeColor="White" BackColor="#E5E5E5"></SelectedItemStyle>
                                                <AlternatingItemStyle Height="20px" BackColor="#E5E5E5" CssClass="tx_tabl"></AlternatingItemStyle>
                                                <ItemStyle Height="18px" BackColor="White" CssClass="tx_tabl"></ItemStyle>
                                                <HeaderStyle Height="35px" CssClass="tx_tit2" VerticalAlign="Middle" HorizontalAlign="Center"
                                                    BackColor="#E5E5E5"></HeaderStyle>
                                                <Columns>
                                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ARRSAPXEP" Visible="false"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="TENMENU" HeaderText="Tên chức năng" HeaderStyle-Font-Bold="true">
                                                        <HeaderStyle Font-Bold="True"></HeaderStyle>
                                                    </asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderText="Tất cả" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                        <HeaderTemplate>
                                                            Tất cả
                                                    <br />
                                                            <asp:CheckBox ID="chkFullAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkFullAll_CheckChange" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkFull" runat="server" AutoPostBack="true" Checked='<%# GetNumber(Eval("Full"))%>'
                                                                ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkFull_CheckedChanged" />
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Hiển thị" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                        <HeaderTemplate>
                                                            Xem
                                                    <br />
                                                            <asp:CheckBox ID="chkXemAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkXemAll_CheckChange" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkXem" runat="server" AutoPostBack="true" OnCheckedChanged="chkXem_CheckedChanged" Checked='<%# GetNumber(Eval("XEM"))%>' ToolTip='<%#Eval("ID")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Tạo mới" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                        <HeaderTemplate>
                                                            Tạo mới
                                                    <br />
                                                            <asp:CheckBox ID="chkTaomoiAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkTaomoiAll_CheckChange" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkTaomoi" runat="server" AutoPostBack="true" OnCheckedChanged="chkTaomoi_CheckedChanged" Checked='<%# GetNumber(Eval("TAOMOI"))%>' ToolTip='<%#Eval("ID")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Lưu" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                        <HeaderTemplate>
                                                            Lưu
                                                    <br />
                                                            <asp:CheckBox ID="chkCapnhatAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkCapnhatAll_CheckChange" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkCapnhat" runat="server" AutoPostBack="true" OnCheckedChanged="chkCapnhat_CheckedChanged" Checked='<%# GetNumber(Eval("CAPNHAT"))%>' ToolTip='<%#Eval("ID")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Xóa" ItemStyle-VerticalAlign="Middle" HeaderStyle-Font-Bold="true"
                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                                        <HeaderTemplate>
                                                            Xóa
                                                    <br />
                                                            <asp:CheckBox ID="chkXoaAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkXoaAll_CheckChange" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkXoa" AutoPostBack="true" OnCheckedChanged="chkXoa_CheckedChanged" runat="server" Checked='<%# GetNumber(Eval("XOA"))%>' ToolTip='<%#Eval("ID")%>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" Width="50px"></HeaderStyle>
                                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="float:right;margin-top:30px;margin-bottom:20px;">
                                            <asp:Button ID="Button1" runat="server" Visible="false" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                            <asp:Button ID="Button2" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="lblquaylai_Click" />
                                                </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <b style="color: red;">
                                                <asp:Literal ID="lstMsgB" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
