<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lenhtamgiam_Home.aspx.cs" Inherits="WEB.GSTP.UserControl.TP.Lenhtamgiam_Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <title></title>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            padding-top: 5px;
        }

        .box {
            height: 450px;
            overflow: auto;
        }

        .form_tt {
            padding-top: 10px;
            margin: 0 auto;
            width: 760px;
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="form_tt" style="width:920px;">
                <h4 class="tleboxchung">Danh sách các bị can sắp hết lệnh tạm giam </h4>
                <div class="boder" style="padding: 10px; width: 900px;">
                    <table class="table1">
                        <tr>
                            <td>
                                <span class="msg_error">
                                    <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
                                <asp:Panel ID="pnPagingTop" runat="server">
                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="42">
                                            <div align="center"><strong>TT</strong></div>
                                        </td>
                                        <td style="width:150px">
                                            <div align="center"><strong>Họ tên</strong></div>
                                        </td>
                                        <td style="width:80px">
                                            <div align="center"><strong>Ngày bắt đầu</strong></div>
                                        </td>
                                        <td style="width:80px">
                                            <div align="center"><strong>Ngày kết thúc</strong></div>
                                        </td>
                                        <td width="70px">
                                            <div align="center"><strong>Mã vụ án</strong></div>
                                        </td>
                                        <td  width="20%">
                                            <div align="center"><strong>Tên vụ án</strong></div>
                                        </td>
                                        <td style="width:80px">
                                            <div align="center"><strong>Cấp xét xử</strong></div>
                                        </td>
                                        <td  style="width:200px">
                                            <div align="center"><strong>Tên đơn vị</strong></div>
                                        </td>
                                         <td  style="width:200px">
                                            <div align="center"><strong>Thông tin QĐ/BP ngăn chặn</strong></div>
                                        </td>
                                    </tr>
                                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <div align="center"><%# Eval("STT") %></div>
                                                </td>
                                                <td><%# Eval("HOTEN") %></td>
                                                <td><%# Eval("NGAYBATDAU") %></td>
                                                <td><%# Eval("NGAYKETTHUC") %></td>
                                                <td><%# Eval("MAVUAN") %></td>
                                                <td><%# Eval("TENVUAN") %></td>
                                                <td><%# Eval("CAPXX") %></td>
                                                <td><%# Eval("TOAAN_TEN") %></td>
                                                <td><%# Eval("CHUCNANG") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </table>
                                <asp:Panel ID="pnPagingBottom" runat="server">
                                    <div class="phantrang_bottom">
                                        <div class="sobanghi">
                                            <asp:HiddenField ID="hdicha" runat="server" />
                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
