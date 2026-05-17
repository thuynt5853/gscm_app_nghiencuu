<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CongBoBanAn.aspx.cs" Inherits="WEB.GSTP.QLAN.CongBoBanAn" Async="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../UI/js/src_duallistbox/bootstrap.min.js"></script>
    <%--<link href="../../UI/js/src_duallistbox/bootstrap.min.css" rel="stylesheet" />--%>
    <link href="modal.css" rel="stylesheet" />
    <style>
        .form_tt {
            margin: 0 auto;
            position: relative;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .t-w-100 {
            width: 100% !important;
            max-width: 100%;
            min-width: 100%;
            resize: vertical;
        }

        .d-modal-title {
            float: left;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
            color: #ffffff;
            border-left: 0px;
            border-right: solid 1px #ea3f42;
            padding-left: 12px;
            padding-right: 12px;
            border-bottom: 0px;
            border-top: 0px;
            background: #db212d;
            font-weight: bold;
            cursor: pointer;
        }

        .overlay {
            position: fixed;
            width: 100%;
            height: 100%;
            z-index: 1100;
            background: rgba(239, 239, 240, 0.3);
            top: 0;
            left: 0px;
            opacity: 0.5;
        }

        .mb-1 {
            margin-bottom: 5px;
        }

        .d-toast {
            position: fixed;
            z-index: 100000;
        }

        .d-toast-body {
            margin-bottom: 0px;
        }

        .d-none {
            display: none;
        }

        .d-width {
            max-width: 300px;
        }

            .d-width .chosen-container-single {
                width: 100% !important;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="modal fade bd-example-modal-lg" id="khongCongBoModal" role="dialog">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header d-modal-title">
                        <h4 class="modal-title">
                            <asp:Label ID="lblTitleModal" runat="server" Text="" />
                        </h4>
                        <a style="color: #ffffff; font-weight: bold; font-size: 130%" class="close" data-dismiss="modal">&times;</a>
                    </div>
                    <div class="modal-body">
                        <div class="box" style="padding-bottom: 10px">
                            <div class="form_tt">
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <asp:HiddenField ID="txtCongBoID" runat="server" />
                                        <tr>
                                            <td class="col-3">Lý do</td>
                                            <td class="col-9 d-width">
                                                <asp:DropDownList ID="rblKhongCongBo" CssClass="chosen-select t-w-100" runat="server" Width="250px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="col-3">Ghi chú</td>
                                            <td>
                                                <asp:TextBox ID="txtGhiChu" CssClass="user t-w-100" runat="server" TextMode="MultiLine"
                                                    MaxLength="255" Height="70">
                                                </asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <div>
                                                    <asp:Label runat="server" ID="lblThongbao" ForeColor="Red" CssClass="d-thongbao"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <table style="width: 100%; padding-top: 15px;">
                            <tr>
                                <td align="center" style="width: 100%">
                                    <asp:Button UseSubmitBehavior="false" ID="btnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnLuu_Click" OnClientClick="ShowLoading()" />
                                    <asp:Button UseSubmitBehavior="false" ID="btnXoaKhongCongBo" runat="server" CssClass="buttoninput" Text="Xóa" OnClientClick="if (!OnClickXoaKhongCongBo()) return false;" OnClick="btnXoaKhongCongBo_Click" />
                                    <asp:Button UseSubmitBehavior="false" ID="btnLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLamMoi_Click" OnClientClick="ShowLoading()" />
                                    <button type="button" class="buttoninput modal-btn-huy" data-dismiss="modal">Đóng</button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
        </div>
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 1050px">


                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="250px"
                                                            AutoPostBack="True" OnSelectedIndexChanged="dropCapxx_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>

                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="250px">
                                                        </asp:DropDownList>
                                                    </div>

                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tội danh/ QHPL</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_toidanh" CssClass="user" runat="server" Width="250px"></asp:TextBox>
                                                    </div>


                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>

                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số BA/QĐ </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>


                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 15px;">
                                                        Từ ngày 
                                                    </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="Sai định dạng dd/MM/yyyy" Style="color: red; margin-left: 15px;" />
                                                        <!-- VALIDATOR SO SÁNH NGÀY -->
                                                        <asp:CustomValidator ID="cvTuNgayAlert" runat="server" ControlToValidate="txtTuNgay" ClientValidationFunction="validateTuNgayMin" ErrorMessage="" Display="None" ValidateEmptyText="true" />
                                                    </div>

                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="65px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; padding-top: 10px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                    <div style="float: left; margin-right: 15px;">
                                                        <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                    </div>

                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái công bố</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlTrangThaiCongBo" CssClass="chosen-select" runat="server" Width="242px">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td align="center">
                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" CausesValidation="true" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click">
                                    </asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
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
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="TT_CB_ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Justify">
                                            <HeaderTemplate>
                                                Thông tin vụ án
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("THONGTIN")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                            HeaderStyle-Width="300px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Trạng thái
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <span class="trangthai">
                                                    <%#Eval("TT_CB_ID_TEXT")%>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div>
                                                    <asp:Button ID="btnDaCongbo" runat="server" Text="Đã công bố" CausesValidation="false" CommandName="btnDaCongbo" Visible="false"
                                                        CommandArgument='<%#Eval("BAQD_CONGBO_ID") %>' CssClass="buttonchitiet  mb-1" OnClientClick="return confirm('Xác nhận BA/QĐ đã công bố tại phần mềm Phần mềm công bố BA/QĐ (congbobanan.toaan.gov.vn)?');"></asp:Button>
                                                    <br />
                                                    <asp:Button ID="btnHaCongbo" runat="server" Text="Hạ bản án" CausesValidation="false" CommandName="btnHaCongbo" Visible="false"
                                                        CommandArgument='<%#Eval("BAQD_CONGBO_ID") %>' CssClass="buttonchitiet  mb-1" OnClientClick="return confirm('Bạn có chắc chắn muốn hạ công bố không?');"></asp:Button>
                                                    <br />
                                                    <asp:Button ID="btnKhongCongBo" runat="server" Text="Không công bố" CausesValidation="false" CommandName="btnKhongCongBo"
                                                        CommandArgument='<%#Eval("BAQD_CONGBO_ID") %>' CssClass="buttonchitiet  mb-1"></asp:Button>
                                                    <br />
                                                    <asp:UpdatePanel ID="pnMaHoaChiTiet" runat="server" UpdateMode="Conditional" defaultbutton="btnDisableEnter">
                                                        <ContentTemplate>
                                                            <button type="button" class="buttonchitiet  mb-1" onclick="popup_MaHoaChiTiet('<%#Eval("BAQD_CONGBO_ID") %>')">Mã hóa bản án</button>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <button type="button" class="buttonchitiet d-btn-anchitiet mb-1" data-hsid="<%#Eval("ID").ToString() %>" data-loaian="<%#Eval("LOAIAN_ID") %>">Chi tiết</button>
                                                    <br />
                                                    <asp:Button ID="lblLyDoKhongCongBo" runat="server" Text="Lý do không công bố" CausesValidation="false" CommandName="btnLyDoKhongCongBo"
                                                        CommandArgument='<%#Eval("BAQD_CONGBO_ID") %>' CssClass="buttonchitiet  mb-1" Visible="false"></asp:Button>
                                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" defaultbutton="btnDisableEnter">
                                                        <ContentTemplate>
                                                            <button type="button" class="buttonchitiet  mb-1" onclick="popup_LichSuCongBo('<%#Eval("BAQD_CONGBO_ID") %>')">Lịch sử</button>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click">
                                    </asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click">
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click">
                                    </asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <script>
        var maCBSelect = 0;
        var rowElement = null;
        function ShowModalAndDisableLoading() {
            $('.modal-backdrop').remove();
            $("#khongCongBoModal").modal('toggle');
            $('#loading').css('display', 'none');
        }
        function OnShowModal() {
            this.ShowModalAndDisableLoading();
        }
        function OnUpdateDone() {
            this.ShowModalAndDisableLoading();
        }
        function OnShowLyDoKhongCongBo() {
            $(document).ready(function () {
                $("#khongCongBoModal").modal('show');
            })
        }
        function OnShowKhongCongBo() {
            $(document).ready(function () {
                $("#khongCongBoModal").modal('show');
            })
        }
        function ShowLoading() {
            $('#loading').css('display', 'inline');
        }
        function OnClickXoaKhongCongBo() {
            let result = confirm('Xóa không công bố ? ');
            if (result)
                this.ShowLoading();
            return result;
        }
        function popup_AnChiTiet(hsID, loaiAnID) {
            var link = "/BaoCao/Thongtinvuviec/";
            switch (loaiAnID) {
                case 2:
                    link += "DanSu";
                    break;
                case 3:
                    link += "HonNhanGiaDinh";
                    break;
                case 4:
                    link += "KinhDoanhThuongMai";
                    break;
                case 5:
                    link += "LaoDong";
                    break;
                case 6:
                    link += "HanhChinh";
                    break;
                case 7:
                    link += "PhaSan";
                    break;
                case 8:
                    link += "BPXLHC";
                    break;
                default:
                    link += "HinhSu";
                    break;
            }
            link += ".aspx?hsID=" + encodeURIComponent(hsID);
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Người tham gia đối tượng", width, height);
        }
        function popup_LichSuCongBo(VuAnID) {
            var link = "/QLAN/CONGBO/LichSuCongBo.aspx?hsID=" + encodeURIComponent(VuAnID);
            var width = 1000;
            var height = 600;
            PopupCenter(link, "Lịch sử công bố BA/QĐ", width, height);
            //window.open(link, '_blank');
        }
        function popup_MaHoaChiTiet(VuAnID) {
            var link = "/QLAN/CONGBO/MaHoaBanAn2.aspx?hsID=" + encodeURIComponent(VuAnID);
            var width = 750;
            var height = 550;
            PopupCenter(link, "Mã hóa bản án chi tiết", width, height);
            //window.open(link, '_blank');
        }
        function LoadDanhsachHoSo() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        $(document).ready(function () {
            $(document).on('click', '.d-btn-anchitiet', function (event) {
                let loaiAn = $(this).data("loaian");
                let hsId = $(this).data("hsid");
                popup_AnChiTiet(hsId, loaiAn);
            });
        });
    </script>
    <script type="text/javascript">
        function validateTuNgayMin(sender, args) {
            var value = document.getElementById('<%= txtTuNgay.ClientID %>').value;

            if (!value) return; // không nhập thì bỏ qua nếu không bắt buộc

            var parts = value.split('/');
            if (parts.length !== 3) return;

            var inputDate = new Date(parts[2], parts[1] - 1, parts[0]); // yyyy, MM-1, dd
            //var minDate = new Date(2026, 2, 1); // 01/03/2026 
            var minDate = new Date(today.getFullYear(), 0, 1); // 01/01 năm nay

            if (inputDate < minDate) {
                alert("Ngày tìm kiếm không được bé hơn ngày 01/03/2026");
                args.IsValid = false;
            } else {
                args.IsValid = true;
            }
        }
    </script>

</asp:Content>
