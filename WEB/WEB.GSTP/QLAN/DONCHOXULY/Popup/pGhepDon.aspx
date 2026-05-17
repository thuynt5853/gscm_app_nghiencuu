<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pGhepDon.aspx.cs" Inherits="WEB.GSTP.QLAN.DONCHOXULY.Popup.pGhepDon" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ghép đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate> 
                <div>
                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                    <style type="text/css">
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }
                        .check_list_vertical table td {
                            padding-right: 15px;
                        }
                        .boxchung {
                            height: auto;
                            overflow: visible;
                        }
                        .disable_btn {
                            min-width: 80px;
                            height: 30px;
                            font-weight: bold;
                            color: #808080;
                            background: url("../img/bg_danhsach.png");
                            padding-left: 15px;
                            padding-right: 15px;
                            cursor: pointer;
                            border: solid 1px #9e9e9e;
                            border-radius: 3px 3px 3px 3px;
                        }
                        .pnKCKN{
                            padding: 50px 0 20px 0;
                        }
                        .loading {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            display: none;
                            z-index: 99;
                            justify-content: center;
                            align-items: center;
                            background-color: rgba(0, 0, 0, 0.5); /* Màu nền semi-transparent */
                        }
                        .loading-spinner {
                            position: absolute;
                            top: 45%;
                            left: 48%;
                            transform: translate(-50%, -50%);
                            border: 4px solid #eeeeee;
                            border-top: 4px solid #3498db;
                            border-radius: 50%;
                            width: 40px;
                            height: 40px;
                            animation: spin 2s linear infinite;
                        }
                        @keyframes spin {
                            0% { transform: rotate(0deg); }
                            100% { transform: rotate(360deg); }
                        }
                    </style>

                    <div id="loading" class="loading">
                        <div class="loading-spinner"></div>
                    </div>

                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin đơn</h4>
                        <div class="boder" style="padding: 10px; margin-right: 10px">
                            <table class="table1">
                                <tr>
                                    <td style="width: 100px;">Loại án</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaiAn" runat="server" CssClass="user"
                                            Width="228px" Height="25px" AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Mã vụ việc</td>
                                    <td>
                                        <asp:TextBox ID="txtMaVuViec" runat="server" CssClass="user"
                                            Width="220px" Height="20px"></asp:TextBox>
                                    </td>
                                    <td style="width: 100px">Tên vụ việc</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuViec" runat="server" CssClass="user"
                                            Width="435px" Height="20px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Người khởi kiện</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiKhoiKien" runat="server" CssClass="user"
                                            Width="220px" Height="20px"></asp:TextBox>
                                    </td>
                                    <td>Số CMND</td>
                                    <td>
                                        <asp:TextBox ID="txtSoCMND" runat="server" CssClass="user" Width="170px"
                                            Height="20px" MaxLength="12"></asp:TextBox>
                                        <span style="margin: 0 15px 0 15px">Năm sinh</span>
                                        <asp:TextBox ID="txtNamSinh" runat="server" CssClass="user"
                                            Width="170px" Height="20px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Người bị kiện</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiBiKien" runat="server" CssClass="user"
                                            Width="220px" Height="20px"></asp:TextBox>
                                    </td>
                                    <td>Nội dung khởi kiện</td>
                                    <td>
                                        <asp:TextBox ID="txtNoiDungKhoiKien" runat="server" CssClass="user"
                                            Width="435px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnTTThuLy" runat="server">
                                    <tr>
                                        <td>Số thụ lý</td>
                                        <td>
                                            <asp:TextBox ID="txtSoThuLy" runat="server" CssClass="user"
                                                Width="220px" Height="20px"></asp:TextBox>
                                        </td>
                                        <td>Ngày thụ lý từ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayThuLyTu" runat="server" CssClass="user" Width="170px"
                                                Height="20px" MaxLength="12"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8"
                                                    runat="server" TargetControlID="txtNgayThuLyTu" Format="dd/MM/yyyy"
                                                    Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server"
                                                    TargetControlID="txtNgayThuLyTu" Mask="99/99/9999" MaskType="Date"
                                                    CultureName="vi-VN" ErrorTooltipEnabled="true"/>
                                            <span style="margin: 0 30px 0 30px">đến</span>
                                            <asp:TextBox ID="txtNgayThuLyDen" runat="server" CssClass="user"
                                                Width="170px" Height="20px" MaxLength="4"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9"
                                                    runat="server" TargetControlID="txtNgayThuLyDen" Format="dd/MM/yyyy"
                                                    Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server"
                                                    TargetControlID="txtNgayThuLyDen" Mask="99/99/9999" MaskType="Date"
                                                    CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <asp:Panel ID="pnTTQDBA" runat="server">
                                    <tr>
                                        <td>Số BQ/QĐ</td>
                                        <td>
                                            <asp:TextBox ID="txtDon_SoBAQD" runat="server" CssClass="user"
                                                Width="220px" Height="20px"></asp:TextBox>
                                        </td>
                                        <td>Ngày BA/QĐ từ</td>
                                        <td>
                                            <asp:TextBox ID="txtDon_NgayBAQDTu" runat="server" CssClass="user" Width="170px"
                                                Height="20px" MaxLength="12"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender10"
                                                    runat="server" TargetControlID="txtDon_NgayBAQDTu" Format="dd/MM/yyyy"
                                                    Enabled="true" PopupPosition="TopLeft" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server"
                                                    TargetControlID="txtDon_NgayBAQDTu" Mask="99/99/9999" MaskType="Date"
                                                    CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <span style="margin: 0 30px 0 30px">đến</span>
                                            <asp:TextBox ID="txtDon_NgayBAQDDen" runat="server" CssClass="user"
                                                Width="170px" Height="20px" MaxLength="4"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender11"
                                                    runat="server" TargetControlID="txtDon_NgayBAQDDen" Format="dd/MM/yyyy"
                                                    Enabled="true" PopupPosition="TopLeft" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server"
                                                    TargetControlID="txtDon_NgayBAQDDen" Mask="99/99/9999" MaskType="Date"
                                                    CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </table>
                        </div>
                    </div>

                    <div style="margin-top:10px;margin-left:10px">
                        <asp:Label runat="server" ID="lblMess" ForeColor="Red"></asp:Label>
                    </div>

                    <div style="padding:10px 0 25px 0; text-align: center">
                        <asp:Button ID="btnTimKiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm"
                            OnClick="TimKiem_Click" OnClientClick="showLoading();" />
                        <asp:Button ID="btnGhepDon" runat="server" CssClass="buttoninput" Text="Ghép đơn"
                            OnClick="GhepDon_Click" />
                        <asp:Button ID="btnTiepNhan" runat="server" CssClass="buttoninput" Text="Tạo vụ việc"
                            OnClick="TiepNhan_Click" />
                        <input type="button" class="buttoninput"
                            onclick="ReloadParent();" value="Quay lại" />
                    </div>

                    <asp:Panel runat="server" ID="pnData" Visible="true">
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                    CssClass="back" Visible="false" OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false"
                                    CssClass="active" Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="2" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="3" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="4" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="5" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="100" OnClick="lbTLast_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false"
                                    CssClass="next" Visible="false" OnClick="lbTNext_Click"></asp:LinkButton>
                                <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so"
                                    AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                    <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None"
                                PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header"
                                AlternatingItemStyle-CssClass="le" ItemStyle-CssClass="chan" Width="100%">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="checkGhepDon" runat="server" AutoPostBack="true" OnCheckedChanged="checkGhepDon_CheckedChanged"/>
                                            <asp:HiddenField ID="hddIdVuViec" runat="server"
                                                Value='<%#Eval("ID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("STT")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate> Mã vụ việc </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("MAVUVIEC")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate> Tên vụ việc </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TENVUVIEC")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate> Tình trạng giải quyết </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TINHTRANGGIAIQUYET")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate> Nguyên đơn </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUYENDON")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="50px"
                                        HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate> Bị đơn </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("BIDON")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center"
                                    Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </div>
                        <div class="phantrang">
                            <div class="sobanghi">
                                <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                            </div>
                            <div class="sotrang">
                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                    CssClass="back" Visible="false" OnClick="lbTBack_Click"></asp:LinkButton>
                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                    CssClass="active" Visible="true" Text="1" OnClick="lbTFirst_Click">
                                </asp:LinkButton>
                                <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="2" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="3" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="4" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="5" OnClick="lbTStep_Click">
                                </asp:LinkButton>
                                <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false"
                                    CssClass="so" Visible="false" Text="100" OnClick="lbTLast_Click">
                                </asp:LinkButton>
                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false"
                                    CssClass="next" Visible="false" OnClick="lbTNext_Click"></asp:LinkButton>
                                <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so"
                                    AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                    <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnDataKCKN" runat="server" CssClass="pnKCKN" Visible="false">
                        <asp:DataGrid ID="dgDataKCKN" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%">
                            <Columns>
                                <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>TT</HeaderTemplate>
                                    <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="KCKNName" HeaderText="Kháng cáo, Kháng nghị" HeaderStyle-Width="66px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="HTNhanDonDonViKN" HeaderText="Hình thức nhận đơn KC, Đơn vị kháng nghị" HeaderStyle-Width="96px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NguoiKCCapKN" HeaderText="Người kháng cáo, Cấp kháng nghị" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="LoaiKCKN" HeaderText="Loại" HeaderStyle-Width="118px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NgayKCKN" HeaderText="Ngày kháng cáo, kháng nghị" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                <asp:BoundColumn DataField="SO_QDBA" HeaderText="Số BA/QĐ" HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                <asp:BoundColumn DataField="NGAYQDBA" HeaderText="Ngày QĐ/BA" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                            <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                            <ItemTemplate >
                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                    CommandArgument='<%#Eval("ID") +";#"+ Eval("IsKhangCao")%>' ToolTip='<%#Eval("TENFILE")%>' />
                            </ItemTemplate>
                            </asp:TemplateColumn>
                            </Columns>
                            <HeaderStyle CssClass="header"></HeaderStyle>
                            <ItemStyle CssClass="chan"></ItemStyle>
                            <PagerStyle Visible="false"></PagerStyle>
                        </asp:DataGrid>
                    </asp:Panel>

                    <div class="boxchung">
                        <h4 class="tleboxchung">Thông tin vụ việc</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <asp:TextBox ID="hdd_Type_Save" runat="server" Visible="false">GhepDon
                                </asp:TextBox>
                                <asp:Panel ID="pnlThuocLoaiAn" runat="server" Visible="false">
                                    <tr>
                                    <td style="width: 115px;">Thuộc loại án</td>
                                        <td style="width: 260px;">
                                            <asp:DropDownList ID="ddlThuocLoaiAn" CssClass="user" runat="server"
                                                Width="250px">
                                                <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Dân sự"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Hôn nhân và gia đình"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Kinh doanh, thương mại"></asp:ListItem>
                                                <asp:ListItem Value="5" Text="Lao động"></asp:ListItem>
                                                <asp:ListItem Value="6" Text="Hành chính"></asp:ListItem>
                                                <asp:ListItem Value="7" Text="Phá sản"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <asp:TextBox ID="hddID_DON" runat="server" Visible="false"></asp:TextBox>
                                    <asp:TextBox ID="hddID_TOAAN" runat="server" Visible="false"></asp:TextBox>
                                    <asp:TextBox ID="hddGIAIDOAN" runat="server" Visible="false"></asp:TextBox>
                                    <td style="width: 115px;">Hình thức nhận đơn</td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlHinhthucnhandon" CssClass="user" runat="server"
                                            Width="250px">
                                            <asp:ListItem Value="1" Text="Trực tiếp"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Qua bưu điện"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Trực tuyến"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 145px;">Loại đơn</td>
                                    <td>
                                        <asp:DropDownList ID="ddlLoaidon" CssClass="user" runat="server"
                                            Width="250px">
                                            <asp:ListItem Value="1" Text="Đơn mới"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến">
                                            </asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Đơn không thuộc thẩm quyền">
                                            </asp:ListItem>
                                            <asp:ListItem Value="5" Text="Đơn có yêu cầu phản tố">
                                            </asp:ListItem>
                                            <asp:ListItem Value="6" Text="Đơn có yêu cầu độc lập">
                                            </asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày ghi trên đơn</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayViet" runat="server" CssClass="user"
                                            Width="241px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender"
                                            runat="server" TargetControlID="txtNgayViet" Format="dd/MM/yyyy"
                                            Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                            TargetControlID="txtNgayViet" Mask="99/99/9999" MaskType="Date"
                                            CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td>Ngày nhận đơn hoặc ngày ghi trên dấu bưu điện <span
                                            class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user"
                                            Width="241px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                            TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                            TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date"
                                            CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Quan hệ pháp luật <span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlQuanhephapluat" CssClass="user" runat="server"
                                            Width="250px" Visible="false"></asp:DropDownList>
                                        <asp:TextBox ID="txtQuanhephapluat" CssClass="user" placeholder=""
                                            runat="server" Width="241px" MaxLength="500" TextMode="MultiLine">
                                        </asp:TextBox>
                                    </td>
                                    <td>QHPL dùng cho thống kê<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlQHPLTK" CssClass="chosen-select" runat="server"
                                            Width="250px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Cán bộ nhận đơn<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlCanbonhandon" CssClass="chosen-select" runat="server"
                                            Width="250px"> </asp:DropDownList>
                                    </td>
                                    <td>Thẩm phán ký nhận đơn</td>
                                    <td>
                                        <asp:DropDownList ID="ddlThamphankynhandon" CssClass="chosen-select"
                                            runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="lbNoidung" runat="server">Nội dung khởi kiện</asp:Label>
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtNDKK" CssClass="user" runat="server" Width="661px"
                                            TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <asp:Panel id="pnDonKhoiKien" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin nguyên đơn (đại diện)</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <asp:Panel ID="cboListND" runat="server" Visible="false">
                                            <td style="width: 115px;">Danh sách đương sự<span
                                                    class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlListND" CssClass="user" runat="server"
                                                    AutoPostBack="True"
                                                    OnSelectedIndexChanged="ddlListND_SelectedIndexChanged"
                                                    Width="250px"></asp:DropDownList>
                                            </td>
                                        </asp:Panel>
                                    </tr>
                                    <tr>
                                        <asp:TextBox ID="txtIdNguyenDon" runat="server" Visible="false">
                                        </asp:TextBox>
                                        <td style="width: 115px;">Nguyên đơn là<span class="batbuoc">(*)</span>
                                        </td>
                                        <td style="width: 260px;">
                                            <asp:DropDownList ID="ddlLoaiNguyendon" CssClass="user"
                                                runat="server" Width="250px" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2">
                                            <asp:CheckBox ID="chkISBVQLNK" Visible="false" runat="server"
                                                Text="Khởi kiện bảo vệ quyền và lợi ích hợp pháp của người khác, lợi ích công cộng và nhà nước" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tên nguyên đơn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server"
                                                Width="241px"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                        <tr>
                                            <td>Mã số thuế:</td>
                                            <td>
                                                <asp:TextBox ID="txtND_MaSoThue" CssClass="user"
                                                    runat="server" Width="241px"></asp:TextBox>
                                            </td>
                                            <td colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlNDD_Tinh_NguyenDon" CssClass="user"
                                                    runat="server" Width="123px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlNDD_Tinh_NguyenDon_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="ddlNDD_Huyen_NguyenDon" CssClass="user"
                                                    runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết </td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Diachichitiet" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Người đại diện</td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Ten" CssClass="user" runat="server"
                                                    Width="241px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Chức vụ</td>
                                            <td>
                                                <asp:TextBox ID="txtND_NDD_Chucvu" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<span class="batbuoc">(*)</span><asp:Literal ID="ltCMNDND"
                                                runat="server"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtND_CMND" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td style="width: 80px;">Quốc tịch<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select" runat="server"
                                                Width="265px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:CheckBox ID="chkBoxCMNDND" runat="server" Text="Không có" />
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnNDCanhan" runat="server">
                                        <tr>
                                            <td>Giới tính</td>
                                            <td>
                                                <asp:DropDownList ID="ddlND_Gioitinh" CssClass="user"
                                                    runat="server" Width="250px">
                                                    <asp:ListItem Value="0" Text="--Chọn--"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>Ngày sinh</td>
                                            <td>
                                                <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user"
                                                    Width="85px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                                    TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy"
                                                    Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                                    TargetControlID="txtND_Ngaysinh" Mask="99/99/9999"
                                                    MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" /> Năm sinh<span
                                                    class="batbuoc">(*)</span>
                                                <asp:TextBox ID="txtND_Namsinh" CssClass="user"
                                                    onkeypress="return isNumber(event)" runat="server"
                                                    Width="90px" MaxLength="4"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="3">
                                                <asp:CheckBox ID="chkND_ONuocNgoai" runat="server"
                                                    Text="Có yếu tố nước ngoài" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi cư trú<asp:Label ID="lblND_Batbuoc2" runat="server"
                                                    ForeColor="Red" Text="(*)"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlTamTru_Tinh_NguyenDon" CssClass="chosen-select"
                                                    runat="server" Width="123px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="ddlTamTru_Huyen_NguyenDon" CssClass="chosen-select"
                                                    runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server"
                                                    Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi làm việc</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtND_NoiLamViec" CssClass="user"
                                                    runat="server" Width="615px" MaxLength="500"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Email</td>
                                        <td>
                                            <asp:TextBox ID="txtND_Email" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>Điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtND_Dienthoai" runat="server"
                                                onkeypress="return isNumber(event)" CssClass="user"
                                                Width="120px"></asp:TextBox> Fax <asp:TextBox ID="txtND_Fax"
                                                runat="server" onkeypress="return isNumber(event)"
                                                CssClass="user" Width="103px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin bị đơn (đại diện)</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <asp:Panel ID="cboListBD" runat="server" Visible="false">
                                            <td style="width: 115px;">Danh sách đương sự<span
                                                    class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlListBD" CssClass="user" runat="server"
                                                    AutoPostBack="True"
                                                    OnSelectedIndexChanged="ddlListBD_SelectedIndexChanged"
                                                    Width="250px"></asp:DropDownList>
                                            </td>
                                        </asp:Panel>
                                    </tr>
                                    <tr>
                                        <asp:TextBox ID="txtIdBiDon" runat="server" Visible="false"></asp:TextBox>
                                        <td style="width: 115px;">Bị đơn là<span class="batbuoc">(*)</span></td>
                                        <td style="width: 260px;">
                                            <asp:DropDownList ID="ddlLoaiBidon" CssClass="user" runat="server"
                                                Width="250px" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlLoaiBidon_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 70px;"></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Tên bị đơn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtBD_Ten" CssClass="user" runat="server"
                                                Width="241px"></asp:TextBox>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <asp:Panel ID="pnBD_Tochuc" runat="server" Visible="false">
                                        <tr>
                                            <td>Mã số thuế:</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_MaSoThue" CssClass="user"
                                                    runat="server" Width="241px"></asp:TextBox>
                                            </td>
                                            <td colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlNDD_Tinh_BiDon" CssClass="user"
                                                    runat="server" Width="123px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlNDD_Tinh_BiDon_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="ddlNDD_Huyen_BiDon" CssClass="user"
                                                    runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_NDD_Diachichitiet" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Người đại diện</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_NDD_ten" CssClass="user" runat="server"
                                                    Width="241px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Chức vụ</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_NDD_Chucvu" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<asp:Literal ID="ltCMNDBD"
                                                runat="server"></asp:Literal>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td style="width: 80px;">Quốc tịch<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlBD_Quoctich" CssClass="chosen-select" runat="server"
                                                Width="265px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:CheckBox ID="chkBoxCMNDBD" runat="server" Text="Không có" />
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnBD_Canhan" runat="server">
                                        <tr>
                                            <td>Giới tính</td>
                                            <td>
                                                <asp:DropDownList ID="ddlBD_Gioitinh" CssClass="user"
                                                    runat="server" Width="250px">
                                                    <asp:ListItem Value="0" Text="--Chọn--"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                                </asp:DropDownList>
                                            <td>Ngày sinh</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_Ngaysinh" runat="server" CssClass="user"
                                                    Width="91px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                    TargetControlID="txtBD_Ngaysinh" Format="dd/MM/yyyy"
                                                    Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                                    TargetControlID="txtBD_Ngaysinh" Mask="99/99/9999"
                                                    MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" /> Năm sinh <asp:TextBox
                                                    ID="txtBD_Namsinh" CssClass="user" runat="server"
                                                    onkeypress="return isNumber(event)" Width="100px"
                                                    MaxLength="4"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="3">
                                                <asp:CheckBox ID="chkBD_ONuocNgoai" runat="server"
                                                    Text="Có yếu tố nước ngoài" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi cư trú</td>
                                            <td>
                                                <asp:DropDownList ID="ddlTamTru_Tinh_BiDon" CssClass="chosen-select"
                                                    runat="server" Width="123px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlTamTru_Tinh_BiDon_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="ddlTamTru_Huyen_BiDon" CssClass="chosen-select"
                                                    runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtBD_Tamtru_Chitiet" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi làm việc</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtBD_NoiLamViec" CssClass="user"
                                                    runat="server" Width="615px" MaxLength="500"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Email</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_Email" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>Điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtBD_Dienthoai" runat="server"
                                                onkeypress="return isNumber(event)" CssClass="user"
                                                Width="120px"></asp:TextBox> Fax <asp:TextBox ID="txtBD_Fax"
                                                runat="server" onkeypress="return isNumber(event)"
                                                CssClass="user" Width="103px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnDonKhangCao" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin kháng cáo</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">
                                            <asp:RadioButton ID="rdChonKhangCao" runat="server" Text="Kháng cáo" Checked="true"/>
                                        </td>
                                        <td colspan="3"></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Ngày viết đơn KC</td>
                                        <td style="width: 260px;">
                                            <asp:TextBox ID="txtNgayVietDonKC" CssClass="user" runat="server" Width="241px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4"
                                                runat="server" TargetControlID="txtNgayVietDonKC" Format="dd/MM/yyyy"
                                                Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server"
                                                TargetControlID="txtNgayVietDonKC" Mask="99/99/9999" MaskType="Date"
                                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 145px;">Ngày kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNgayKC" CssClass="user" runat="server" Width="241px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5"
                                                runat="server" TargetControlID="txtNgayKC" Format="dd/MM/yyyy"
                                                Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server"
                                                TargetControlID="txtNgayKC" Mask="99/99/9999" MaskType="Date"
                                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Tên người kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlTenNguoiKC" CssClass="user" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                        <td>Loại kháng cáo<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdLoaiKC" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Selected="True">Bản án</asp:ListItem>
                                                <asp:ListItem Value="1">Quyết định</asp:ListItem>
                                                <asp:ListItem Value="2">Quyết định khác</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 115px;">Số QD/BA<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtSoQDBA" CssClass="user" runat="server" Width="241px" MaxLength="10"></asp:TextBox>
                                        </td>
                                        <td>Ngày kháng cáo quá hạn<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdNgayKCQuaHan" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0" Selected="True">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày QD/BA</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayQDBA" CssClass="user" runat="server" Width="241px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6"
                                                runat="server" TargetControlID="txtNgayQDBA" Format="dd/MM/yyyy"
                                                Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server"
                                                TargetControlID="txtNgayQDBA" Mask="99/99/9999" MaskType="Date"
                                                CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Toà ra QD/BA</td>
                                        <td>
                                            <asp:DropDownList ID="ddlToaRaQDBA" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung kháng cáo</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNoiDungKC" CssClass="user" runat="server" Width="666px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File đính kèm</td>
                                        <td>
                                            <asp:HiddenField ID="hddFilePath_KC" runat="server" />
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoadKhangCao" runat="server" CompleteBackColor="Lime" 
                                                UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadKhangCao_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnDonKhac" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Thông tin đơn</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Người đứng đơn</td>
                                        <td style="width: 260px;">  
                                            <asp:DropDownList ID="ddlDK_NguoiDungDon" CssClass="user"
                                                runat="server" Width="250px" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlDK_NguoiDungDon_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                        <td>Họ tên<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDK_HoTen" CssClass="user" runat="server"
                                                Width="241px"></asp:TextBox>
                                        </td>
                                        <td style="width: 145px">Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlDK_TCTT" runat="server" Width="250px" CssClass="chosen-select"></asp:DropDownList>
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnDK_ToChuc" runat="server" Visible="false">
                                        <tr>
                                            <td>Mã số thuế:</td>
                                            <td>
                                                <asp:TextBox ID="txtDK_MaSoThue" CssClass="user"
                                                    runat="server" Width="241px"></asp:TextBox>
                                            </td>
                                            <td colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td>Địa chỉ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlDK_NDD_Tinh" CssClass="user"
                                                    runat="server" Width="123px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlDK_NDD_Tinh_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="ddlDK_NDD_Huyen" CssClass="user"
                                                    runat="server" Width="123px"></asp:DropDownList>
                                            </td>
                                            <td>Chi tiết </td>
                                            <td>
                                                <asp:TextBox ID="txtDK_NDD_DiaChiChiTiet" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Người đại diện</td>
                                            <td>
                                                <asp:TextBox ID="txtDK_NguoiDaiDien" CssClass="user" runat="server"
                                                    Width="241px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Chức vụ</td>
                                            <td>
                                                <asp:TextBox ID="txtDK_ChucVu" CssClass="user"
                                                    runat="server" Width="257px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Số CMND/CCCD<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtDK_SoCMND" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>Ngày sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtDK_NgaySinh" runat="server" CssClass="user"
                                                Width="85px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server"
                                                TargetControlID="txtDK_NgaySinh" Format="dd/MM/yyyy"
                                                Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server"
                                                TargetControlID="txtDK_NgaySinh" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN"
                                                ErrorTooltipEnabled="true" /> 
                                            Năm sinh<span class="batbuoc">(*)</span>
                                            <asp:TextBox ID="txtDK_NamSinh" CssClass="user"
                                                onkeypress="return isNumber(event)" runat="server"
                                                Width="74px" MaxLength="4"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:CheckBox ID="chkDK_CMNDND" runat="server" Text="Không có" />
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnDK_CaNhan" runat="server">
                                        <tr>
                                            <td>Giới tính</td>
                                            <td>
                                                <asp:DropDownList ID="ddlDK_GioiTinh" CssClass="user"
                                                    runat="server" Width="250px">
                                                    <asp:ListItem Value="0" Text="--Chọn--"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nơi cư trú(Tỉnh/TP)</td>
                                            <td>
                                                <asp:DropDownList ID="ddlDK_TamTru_Tinh" CssClass="chosen-select"
                                                    runat="server" Width="250px" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlDK_TamTru_Tinh_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                            <td>Quận/Huyện</td>
                                            <td>
                                                <asp:DropDownList ID="ddlDK_TamTru_Huyen" CssClass="chosen-select"
                                                    runat="server" Width="250px"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Địa chỉ chi tiết</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtDK_DiaChiChiTiet" CssClass="user" runat="server"
                                                    Width="662px" MaxLength="250"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Email</td>
                                        <td>
                                            <asp:TextBox ID="txtDK_Email" CssClass="user" runat="server"
                                                Width="241px" MaxLength="250"></asp:TextBox>
                                        </td>
                                        <td>Điện thoại</td>
                                        <td>
                                            <asp:TextBox ID="txtDK_DienThoai" runat="server"
                                                onkeypress="return isNumber(event)" CssClass="user"
                                                Width="241px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung đơn</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtDK_NoiDungDon" CssClass="user" runat="server" Width="662px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>

                    <div style="margin-top:10px;margin-left:10px">
                        <asp:Label runat="server" ID="lstMsgB" ForeColor="Red"></asp:Label>
                    </div>

                    <div style="padding:10px 0 25px 0; text-align: center">
                        <asp:Button ID="btnLuu" runat="server" CssClass="buttoninput" Text="Lưu"
                            OnClick="Luu_Click" />
                        <%--<asp:Button ID="btnLuuVaChonXuLy" runat="server" CssClass="buttoninput"
                            Text="Lưu & Chọn xử lý" />
                        <asp:Button ID="btnLuuVaThemMoi" runat="server" CssClass="buttoninput"
                            Text="Lưu & Thêm mới" />--%>
                        <input type="button" class="buttoninput"
                            onclick="ReloadParent();" value="Quay lại" />
                    </div>

                </div>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function ReloadParent(){
                        window.close();
                    }
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: false }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) {
                            $(selector).chosen(config[selector]);
                        }
                    }
                    // Function to show the loading animation
                    function showLoading() {
                        document.getElementById('loading').style.display = 'block';
                    }
                    // Function to hide the loading animation
                    function hideLoading() {
                        document.getElementById('loading').style.display = 'none';
                    }
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>

</html>