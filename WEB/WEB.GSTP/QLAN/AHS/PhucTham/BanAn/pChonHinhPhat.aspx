<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pChonHinhPhat.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.BanAn.pChonHinhPhat" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chọn hình phạt</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    
    
<script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <style type="text/css">
            body {
                width: 98%;
                margin-left: 1%;
                min-width: 0px;
                overflow-y: hidden;
                overflow-x: auto;
            }

            .tdWidthTblToaAn {
                width: 120px;
            }

            .check_list_vertical table td {
                padding-right: 15px;
            }
        </style>

        <div class="boxchung">
            <h4 class="tleboxchung">Cập nhật hình phạt cho bị can</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td style="width: 100px;"><b>Tên bị can</b></td>
                        <td>
                            <b>
                                <asp:Literal ID="lttTenBiCao" runat="server"></asp:Literal></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px;"><b>Tội danh</b></td>
                        <td>
                            <b>
                                <asp:Literal ID="lttToiDanh" runat="server"></asp:Literal></b>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2"><b>Hình phạt</b></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="margin: 5px; text-align: center; width: 95%">
                                <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput"
                                    Text="Lưu" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                                <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                            </div>
                            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Repeater ID="rptHP" runat="server" OnItemDataBound="rptHP_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="42">
                                                <div align="center"><strong>Chọn</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Hình phạt</strong></div>
                                            </td>
                                            <td width="250px">
                                                <div align="center"><strong>Giá trị</strong></div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div style="float: left; width: 100%; text-align: center;">
                                                <asp:CheckBox ID="chk" runat="server"/>
                                            </div>
                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("HinhPhatID") %>' />
                                        </td>
                                        <td><%# Eval("TenHinhPhat") %></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                RepeatDirection="Horizontal" Visible="false">
                                                <asp:ListItem Selected="True" Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                            <!-------------------------->
                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="80%" runat="server" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                            <!-------------------------->
                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                <asp:TextBox ID="txtNam" CssClass="user" Width="40px" runat="server" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                năm
                                                <asp:TextBox ID="txtThang" CssClass="user" Width="40px" runat="server" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                tháng
                                                <asp:TextBox ID="txtNgay" CssClass="user" Width="40px" runat="server" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                ngày
                                            </asp:Panel>
                                            <!-------------------------->
                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="40%" runat="server" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                hoặc
                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user" Width="40%" Text="0" onkeypress="return isNumber(event)"></asp:TextBox>

                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>

                        </td>
                    </tr>
                </table>
            </div>
        </div>

    </form>
</body>
</html>
