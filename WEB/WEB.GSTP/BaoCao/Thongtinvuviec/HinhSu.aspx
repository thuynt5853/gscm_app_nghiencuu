<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HinhSu.aspx.cs" Inherits="WEB.GSTP.BaoCao.Thongtinvuviec.HinhSu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin chi tiết vụ án</title>
    <link href="../../UI/css/style.css" rel="stylesheet" />
    <link href="../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../UI/js/jquery-ui.min.js"></script>
</head>
<body style="min-width: 0px !important;">
    <form id="form1" runat="server">
        <div class="home_index" id="Home_index" style="margin-bottom: 35px; margin-top: 10px;">
            <div id="splitter">
                <div id="pnLeft">
                    <div class="headerleft">
                        Giai đoạn
                    </div>
                    <div id="divTreeMenuLeft" style="float: left; height: 72vh; padding-top: 10px; padding-left: 5px; background: #fcfdfd; margin-bottom: 20px; overflow: auto; overflow-x: hidden; border-left: solid 1px #d1d1d1; border-bottom: solid 1px #d1d1d1;">
                        <asp:Literal ID="lstMess" runat="server"></asp:Literal>
                        <asp:TreeView ID="tvOne" runat="server" Width="96%" NodeWrap="True" NodeIndent="7" ShowLines="false" EnableClientScript="False" OnSelectedNodeChanged="tvOne_SelectedNodeChanged">
                            <NodeStyle ImageUrl="~/UI/img/folder.gif" HorizontalPadding="3" Width="100%" ForeColor="#222222" Font-Size="14px"
                                Font-Names="Arial,Helvetica,sans-serif" VerticalPadding="5px" />
                            <ParentNodeStyle ImageUrl="~/UI/img/root.gif" Font-Size="14px" ForeColor="#003317" />
                            <RootNodeStyle ImageUrl="~/UI/img/root.gif" Font-Size="14px" ForeColor="#003317" />
                            <SelectedNodeStyle Font-Size="14px" Font-Bold="true" ForeColor="#e3393c" BackColor="#f5f5f5" />
                            <DataBindings>
                                <asp:TreeNodeBinding DataMember="menuitem" TextField="Text" ToolTipField="Text" ValueField="value" />
                            </DataBindings>
                        </asp:TreeView>
                    </div>
                </div>
                <div id="pnRight">
                    <div class="box">
                        <div class="box_nd" style="padding: 0px;">
                            <div class="truong" style="margin-top: 0px;">
                                <asp:HiddenField ID="hddGiaiDoan" runat="server" Value="0" />
                                <asp:HiddenField ID="hddToaSoTham" runat="server" Value="0" />
                                <asp:HiddenField ID="hddToaPhucTham" runat="server" Value="0" />
                                <table class="table1">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblTenVuViec" CssClass="ThongTinCTVuViec" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblTenToaAn" CssClass="ThongTinCTVuViec ThongTinCTVuViec_TenToaAn" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="cmdThuLy" CssClass="menubutton_TTCT" runat="server" Text='Thụ lý' OnClick="cmdThuLy_Click" />
                                            <asp:Button ID="cmdHDXX" CssClass="menubutton_TTCT" runat="server" Text='Hội đồng xét xử' OnClick="cmdHDXX_Click" />
                                            <asp:Button ID="cmdDuongSu" CssClass="menubutton_TTCT" runat="server" Text='Bị can / bị cáo' OnClick="cmdDuongSu_Click" />
                                            <asp:Button ID="cmdQuyetDinh" CssClass="menubutton_TTCT" runat="server" Text='Quyết định' OnClick="cmdQuyetDinh_Click" />
                                            <asp:Button ID="cmdBanAn" CssClass="menubutton_TTCT" runat="server" Text='Bản án' OnClick="cmdBanAn_Click" />
                                            <asp:Button ID="cmdKhangCao" CssClass="menubutton_TTCT" runat="server" Text='Kháng cáo' OnClick="cmdKhangCao_Click" />
                                            <asp:Button ID="cmdKhangNghi" CssClass="menubutton_TTCT" runat="server" Text='Kháng nghị' OnClick="cmdKhangNghi_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <div class="phantrang" id="divPhanTrangF" runat="server">
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
                                            <asp:Panel ID="pnThuLy" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListThuLy" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="TruongHopThuLy" HeaderText="Trường hợp thụ lý" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SOTHULY" HeaderText="Số thụ lý" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYTHULY" HeaderText="Ngày thụ lý" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="THOIHANTUNGAY" HeaderText="Từ ngày" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="THOIHANDENNGAY" HeaderText="Đến ngày" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>
                                            <asp:Panel ID="pnHDXX" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListHDXX" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="TENVAITRO" HeaderText="Vai trò tiến hành tố tụng" HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TENNGUOITHTT" HeaderText="Họ và tên" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NguoiPhanCong" HeaderText="Người phân công" HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYKETTHUC" HeaderText="Ngày kết thúc" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>

                                            <asp:Panel ID="pnDuongSu" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListDuongSu" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                            <%--            <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>Bị can đầu vụ</HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkDauVu" runat="server" Checked='<%# GetNumber(Eval("BICANDAUVU"))%>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="TenBiCao" HeaderText="Tên bị can/bị cáo" HeaderStyle-Width="210px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NgayThamGia" HeaderText="Ngày tham gia" HeaderStyle-Width="84px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NamSinh" HeaderText="Năm sinh" HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="DCTamTru" HeaderText="Địa chỉ tạm trú" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>--%>
                                                        
                                                        <asp:BoundColumn DataField="COLUMN_1" HeaderText="Thông tin bị cáo" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
<%--                                                        <asp:BoundColumn DataField="COLUMN_2" HeaderText="Ngày tham gia" HeaderStyle-Width="84px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>--%>
                                                        <asp:BoundColumn DataField="COLUMN_3" HeaderText="Địa chỉ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_4" HeaderText="Giới tính" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_5" HeaderText="Tội danh" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_6" HeaderText="Hình phạt" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_7" HeaderText="Kháng cáo" HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td"></asp:BoundColumn>


                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>

                                            <asp:Panel ID="pnQuyetDinh" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListQuyetDinh" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="TenQD" HeaderText="Tên Quyết định" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LyDo" HeaderText="Lý do" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số Quyết định" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra Quyết định" HeaderStyle-Width="63px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NguoiKy" HeaderText="Người ký" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="HIEULUCTU" HeaderText="Hiệu lực từ" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="HIEULUCDEN" HeaderText="Hiệu lực đến" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>

                                            <asp:Panel ID="pnBanAn" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListBanAn" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SOBANAN" HeaderText="Số bản án" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYBANAN" HeaderText="Ngày bản án" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="KETQUA" HeaderText="Kết quả" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LYDO" HeaderText="Lý do" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ANLE" HeaderText="Áp dụng án lệ?" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="QUAHAN" HeaderText="Vụ việc quá hạn luật định" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>
                                            
                                            <asp:Panel ID="pnKhangCao" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListKhangCao" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
                                       <%--                 <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại kháng cáo" HeaderStyle-Width="88px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng cáo" HeaderStyle-Width="93px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="QUAHAN" HeaderText="Quá hạn" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>--%>


                                                        <asp:TemplateColumn HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="COLUMN_1" HeaderText="Người kháng cáo" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_2" HeaderText="Loại kháng cáo" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_3" HeaderText="Ngày kháng cáo" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_4" HeaderText="Số BA/QĐ" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_5" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_6" HeaderText="Nội dung kháng cáo"  HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_7" HeaderText="Quá hạn" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>

                                            <asp:Panel ID="pnKhangNghi" runat="server" Visible="false">
                                                <asp:DataGrid ID="dgListKhangNghi" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%">
                                                    <Columns>
<%--                                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại kháng nghị" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng nghị" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>--%>


                                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>TT</HeaderTemplate>
                                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="COLUMN_1" HeaderText="Cấp kháng nghị" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_2" HeaderText="Loại kháng nghị" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_3" HeaderText="Ngày kháng nghị" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_4" HeaderText="Số BA/QĐ" HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_5" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center"  HeaderStyle-CssClass="header_td" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="COLUMN_6" HeaderText="Nội dung kháng nghị" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td"></asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="chan"></ItemStyle>
                                                    <PagerStyle Visible="false"></PagerStyle>
                                                </asp:DataGrid>
                                            </asp:Panel>

                                            <div class="phantrang" id="divPhanTrangB" runat="server">
                                                <div class="sobanghi">
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
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
<script src="../../UI/js/chosen.jquery.js"></script>
<script src="../../UI/js/init.js"></script>
<script src="../../UI/js/jquery.enhsplitter.js"></script>
<script>
    jQuery(function ($) {
        $('#splitter').enhsplitter({ handle: 'bar', position: 140, leftMinSize: 0, fixed: false });
    });
</script>
</html>
