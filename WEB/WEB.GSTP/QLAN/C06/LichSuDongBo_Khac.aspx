<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LichSuDongBo_Khac.aspx.cs" Inherits="WEB.GSTP.QLAN.C06.LichSuDongBo_Khac" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Danh sách đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="boxchung">
            <h4 class="tleboxchung">Danh sách bản ghi đã gửi</h4>
            <div class="boder" style="padding: 10px;">
                <table class="table1">
                    <tr>
                        <td>
                            <asp:DataGrid ID="ahsHis" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>

                                    <asp:BoundColumn DataField="STT" HeaderText="STT" ItemStyle-HorizontalAlign="Center" />

                                    <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án" />

                                    <asp:TemplateColumn HeaderText="Thông tin vụ án">
                                        <ItemTemplate>
                                            <i>Mã vụ án:</i> <b><%# Eval("MavuAn") %></b><br />
                                            <i>Tên vụ án:</i> <b><%# Eval("TenVuAn") %></b><br />
                                            <i>Cấp xét xử:</i> <b><%# Eval("CAPXX") %></b><br />
                                            <i>Thụ lý:</i> <b><%# Eval("THULY") %></b><br />
                                            <i>Thẩm phán:</i> <b><%# Eval("THAMPHAN") %></b>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderText="Thông tin bị cáo">
                                        <ItemTemplate>
                                            <i>Tên bị cáo:</i> <b><%# Eval("BICAN_TEN") %></b><br />
                                            <i>Ngày sinh:</i> <b><%# Eval("BICAN_NGAYSINH") %></b><br />
                                            <i>Số CCCD:</i> <b><%# Eval("BICAN_SO_CCCD") %></b>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn HeaderText="Kết quả giải quyết">
                                        <ItemTemplate>
                                            <i>Số BA/QD:</i> <%# Eval("BANAN_SO_BAN_AN") %><br />
                                            <i>Ngày BA/QD:</i> <%# Eval("BANAN_NGAY_BA") %><br />
                                            <i>Tội danh:</i> <b><%# Eval("TENTOIDANH") %></b><br />
                                            <br />
                                            <i>Hình phạt tổng hợp:</i> <b><%# Eval("TENHINHPHAT") %></b><br />
                                            <i>Ngày hiệu lực:</i> <%# Eval("BICAN_NGAYHIEULUC") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <asp:BoundColumn DataField="GHICHU" HeaderText="Ghi chú" />

                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái bản ghi</HeaderTemplate>
                                        <ItemTemplate>
                                            <span class="trangthai">
                                                <%#Eval("trangThaiBanGhi")%>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <%-- <asp:BoundField DataField="NGAYDONGBO" HeaderText="Ngày đồng bộ" />--%>


                                    <asp:TemplateColumn HeaderText="Thao tác">
                                        <ItemTemplate>
                                            <i>Tên thao tác:</i> <b><%#Eval("LOAI_HANH_DONG")%></b><br />
                                            <i>Tài thực hiện:</i> <b><%#Eval("NGUOITHUCHIEN")%></b> <br />
                                            <i>Ngày thực hiện:</i> <b><%#Eval("NGAYTHUCHIEN")%></b>
                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="true"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </td>
                        <td>
                            <asp:DataGrid ID="adsDgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án" HeaderStyle-Width="70px"
                                        ItemStyle-HorizontalAlign="center" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Mã vụ án</HeaderTemplate>
                                        <ItemTemplate><%#Eval("MAVUAN")%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                        <HeaderTemplate>Thông tin vụ án</HeaderTemplate>
                                        <ItemTemplate>
                                            <i>Tên vụ việc:</i> <b><%#Eval("TENVUAN")%></b><br />
                                            <i>Cấp xét xử:</i> <b><%#Eval("CAPXX")%></b><br />
                                            <i>Thụ lý:</i> <b><%#Eval("THULY")%></b><br />
                                            <i>Thẩm phán:</i> <b><%#Eval("THAMPHAN")%></b><br />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                        <HeaderTemplate>Thông tin đương sự</HeaderTemplate>
                                        <ItemTemplate>
                                            <i>Tư cách tố tụng:</i> <b><%#Eval("TENTUCACHTOTUNG")%></b><br />
                                            <i>Tên đương sự:</i> <b><%#Eval("HOTENDUONGSU")%></b><br />
                                            <i>Ngày sinh:</i> <b><%#Eval("NGAYSINHDUONGSU")%></b><br />
                                            <i>CCCD:</i> <b><%#Eval("SOGIAYTODUONGSU")%></b><br />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                        <HeaderTemplate>Kết quả giải quyết</HeaderTemplate>
                                        <ItemTemplate>
                                            <i>Số BA/QD:</i> <%#Eval("SOBANANORQD")%><br />
                                            <i>Ngày BA/QD:</i> <%#Eval("NGAYRABANAN")%><br />
                                            <b><i>Ngày hiệu lực:</i></b> <%#Eval("NGAYHIEULUCBA")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Tình trạng đồng bộ</HeaderTemplate>
                                        <ItemTemplate>
                                            <span class="trangthai">
                                                <%#Eval("trangThaiBanGhi")%>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Ghi chú</HeaderTemplate>
                                        <ItemTemplate><span class="trangthai"><%#Eval("ghiChu")%></span></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>
                                            <i>Tài khoản gửi:</i> <%#Eval("TAIKHOANGUI")%><br />
                                            <i>Ngày gửi:</i> <%#Eval("NGAYGUI")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="90px">
                                        <HeaderTemplate>Người tạo</HeaderTemplate>
                                        <ItemTemplate>
                                            <div style="width: 90px;"><%#Eval("NGUOITAO")%></div>
                                            <br />
                                            <%# Eval("NgayTao") %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="true"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

    </form>
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
</html>
