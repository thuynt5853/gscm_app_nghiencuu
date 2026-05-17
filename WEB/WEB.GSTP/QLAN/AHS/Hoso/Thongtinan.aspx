<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Thongtinan.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.Hoso.Thongtinan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDSBiCao.ascx" TagPrefix="uc1" TagName="uDSBiCao" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDSNguoiThamGiaToTung.ascx" TagPrefix="uc1" TagName="uDSNguoiThamGiaToTung" %>
<%@ Register Src="~/QLAN/AHS/Hoso/Popup/uDsThuLy.ascx" TagPrefix="uc1" TagName="uDsThuLy" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCaoID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddCaoTrangID" runat="server" Value="0" />
    <asp:HiddenField ID="hddMaGiaiDoan" runat="server" Value="0" />
    <!------------------------------------------->
    <style>
        .button_right {
            float: right;
            text-align: center;
            margin-left: 10px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateVuAn" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClick="cmdUpdateVuAn_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput"
                        Text="Lưu & Chọn xử lý" OnClientClick="return validate_all();"
                        OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClientClick="return validate_all();"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div>
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group">Thông tin bàn giao hồ sơ và cáo trạng của VKS</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <table class="table1">

                                <tr>
                                    <td style="width: 120px;">Trường hợp giao nhận <span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:DropDownList ID="dropTrangThaiGiaoNhan" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                        </asp:DropDownList></td>
                                    <td style="width: 115px;">Quyết định truy tố</td>
                                    <td>
                                        <asp:DropDownList ID="dropQuyetDinhTruyTo" CssClass="chosen-select" runat="server"
                                            Width="160px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Số bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanCaoTrang" runat="server" CssClass="user align_right"
                                            Width="242px"></asp:TextBox>
                                    </td>
                                    <td>Ngày bản cáo trạng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBanCaoTrang" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanCaoTrang" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayBanCaoTrang" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayBanCaoTrang" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Số bút lục<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoButLuc" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td>Ngày giao<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayGiao" runat="server" CssClass="user" Width="153px"
                                            MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayGiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server"
                                            ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayGiao"
                                            InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                    </td>
                                </tr>

                            </table>
                        </div>
                    </div>
                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_green">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <table class="table1">
                                <asp:Panel ID="pnMaVuAn" runat="server">
                                    <tr>
                                        <td style="width: 120px;">Mã vụ án</td>
                                        <td style="width: 35%;">
                                            <asp:TextBox ID="txtMaVuAn" CssClass="user" placeholder="Mã vụ án tự sinh"
                                                ReadOnly="true" runat="server" Width="150px" MaxLength="50" Enabled="false"></asp:TextBox>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td style="width: 115px;">Tên vụ án<span class="batbuoc">(*)</span></td>
                                    <td style="width: 250px;">
                                        <asp:TextBox ID="txtTenVuAn" CssClass="user" placeholder="Tên bị can đầu vụ - tội danh"
                                            runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                    <td style="width: 120px;">Mức độ nghiêm trọng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="dropLoaiToiPham" CssClass="chosen-select"
                                            runat="server" Width="160px">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td>Tên khác của vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtTenVuAnKhac" CssClass="user"
                                            runat="server" Width="242px"></asp:TextBox></td>
                                    <td>Ngày xảy ra vụ án</td>
                                    <td>
                                        <asp:TextBox ID="txtNgayXayra" runat="server" CssClass="user" onkeypress="return isNumber(event)"
                                            Width="65px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                            TargetControlID="txtNgayXayra" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server"
                                            TargetControlID="txtNgayXayra" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                            ErrorTooltipEnabled="true" />
                                        Giờ
                                        <asp:DropDownList ID="dropGio" runat="server" CssClass="chosen-select" Width="60">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="display: none">
                                    <td>Số bị can </td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCan" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="50"></asp:TextBox>
                                    </td>
                                    <td>Số bị can tạm giam</td>
                                    <td>
                                        <asp:TextBox ID="txtSoBiCanTamGiam" CssClass="user align_right"
                                            onkeypress="return isNumber(event)" runat="server" Enabled="false" Text="0"
                                            Width="145px" MaxLength="60"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!-------------------------------->
                    <asp:Panel ID="pnToiDanhChung" runat="server" Visible="false">
                        <div class="boxchung">
                            <h4 class="tleboxchung bg_title_group">Tội danh áp dụng cho các bị can</h4>
                            <div class="boder" style="padding: 5px 10px;">
                                <asp:Repeater ID="rptToiDanh" runat="server"
                                    OnItemDataBound="rptToiDanh_ItemDataBound" OnItemCommand="rptToiDanh_ItemCommand">
                                    <HeaderTemplate>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42">
                                                    <div align="center"><strong>STT</strong></div>
                                                </td>
                                                <td width="150px">
                                                    <div align="center"><strong>Bộ luật</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Điều</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Khoản</strong></div>
                                                </td>
                                                <td width="50px">
                                                    <div align="center"><strong>Điểm</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Tội danh</strong></div>
                                                </td>
                                                <td width="60px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 100%; text-align: center;">
                                                    <%#Eval("STT") %>
                                                </div>
                                            </td>
                                            <td><%# Eval("TenBoLuat") %></td>
                                            <td><%# Eval("Dieu") %></td>
                                            <td><%# Eval("Khoan") %></td>
                                            <td><%# Eval("Diem") %></td>
                                            <td>
                                                <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID") %>' />
                                                <asp:HiddenField ID="hdBcID" runat="server" value='<%#Eval("BICANID") %>'/>
                                                <asp:HiddenField ID="hddToiDanhID" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                                <asp:HiddenField ID="hddArrSapXep" runat="server" Value='<%#Eval("ArrSapXep") %>' />
                                                <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                                <asp:HiddenField ID="hddBoLuatID" runat="server" Value='<%#Eval("DieuLuatID") %>' />
                                                <asp:HiddenField ID="hddLoaiToiPham" runat="server" Value='<%#Eval("LoaiToiPham") %>' />

                                                <asp:TextBox ID="txtTenToiDanh" CssClass="user" Width="98%"
                                                    Font-Bold="true" runat="server" Text='<%#Eval("TENTOIDANH") %>'
                                                    Visible='<%# Convert.ToInt16( Eval("IsEdit")+"")==1?true:false  %>'></asp:TextBox>
                                                <div style='display: <%# Convert.ToInt16( Eval("IsEdit")+"")==1? "none":"block"  %>'>
                                                    <%#Eval("TENTOIDANH") %>
                                                </div>
                                            </td>
                                            <td>
                                                <div align="center">
                                                    <asp:LinkButton ID="lkXoa" runat="server"
                                                        Text="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"
                                                        CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="xoa"></asp:LinkButton>
                                                </div>
                                            </td>
                                            <td style="display: none;">
                                                <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>


                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách bị can</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemBiCao" runat="server"
                                OnClick="lkThemBiCao_Click" OnClientClick="return validate();"
                                CssClass="buttonpopup them_user">Thêm bị can</asp:LinkButton>
                            <uc1:uDSBiCao runat="server" ID="uDSBiCao" />
                        </div>
                    </div>

                    <!-------------------------------->
                    <div class="boxchung">
                        <h4 class="tleboxchung bg_title_group bg_yellow">Danh sách người tham gia tố tụng</h4>
                        <div class="boder" style="padding: 5px 10px;">
                            <asp:LinkButton ID="lkThemNguoiTGTT" runat="server"
                                OnClick="lkThemNguoiTGTT_Click" OnClientClick="return validate();"
                                CssClass="buttonpopup them_user">Thêm người tham gia tố tụng</asp:LinkButton>

                            <uc1:uDSNguoiThamGiaToTung runat="server" ID="uDSNguoiThamGiaToTung" />
                        </div>
                    </div>

                    <!-------------------------------->
                    <asp:Panel ID="pnThuLy" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung bg_title_group bg_yellow">Thụ lý</h4>
                            <div class="boder" style="padding: 5px 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 125px;">Thụ lý vụ án</td>
                                        <td colspan="3">
                                            <asp:RadioButtonList ID="rdThuLy" runat="server" RepeatDirection="Horizontal" AutoPostBack="true"
                                                OnSelectedIndexChanged="rdThuLy_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Selected="true">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>
                                    <asp:Panel ID="pnEditThuLy" runat="server" Visible="false">
                                        <tr>
                                            <td>Trường hợp thụ lý<span class="batbuoc">(*)</span></td>
                                            <td colspan="3">
                                                <asp:DropDownList ID="ddTruongHopTL" CssClass="chosen-select" runat="server" Width="422px"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddTruongHopTL_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Ngày thụ lý<span class="batbuoc">(*)</span></td>

                                            <td style="width: 180px;">
                                                <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user" Width="100px"
                                                    onkeypress="return isNumber(event)"
                                                    AutoPostBack="True" OnTextChanged="txtNgayThuLy_TextChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy"
                                                    Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy"
                                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td style="width: 115px;">Số thụ lý<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtSoThuLy" CssClass="user align_right" runat="server" Width="100px"></asp:TextBox></td>

                                        </tr>

                                        <asp:Panel ID="pnlNoidung" runat="server" Visible="false">
                                            <tr>
                                                <td style="width: 115px;">Nội dung</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlNoidung" CssClass="chosen-select"
                                                        runat="server" Width="377px" AutoPostBack="true" OnSelectedIndexChanged="ddlNoidung_SelectedIndexChanged">
            <%--                                            <asp:ListItem Value="0" Text="--Chọn--" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="2241" Text="Xét xử lại phần Dân sự"></asp:ListItem>
                                                        <asp:ListItem Value="2242" Text="Xét xử lại phần bồi thường"></asp:ListItem>
                                                        <asp:ListItem Value="2243" Text="Xét xử lại toàn bộ bản án"></asp:ListItem>
                                                        <asp:ListItem Value="2244" Text="Khác"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                                <asp:Panel ID="pnlGhichu" runat="server" Visible="false">
                                                    <td style="width:80px;">Ghi chú</td>
                                                    <td>
                                                        <asp:TextBox ID="txtGhichu" CssClass="user"                                       
                                                            runat="server" Width="400px" MaxLength="250"></asp:TextBox>
                                                    </td>
                                                </asp:Panel>
                                            </tr>
                                        </asp:Panel>
                            
                                        <asp:Panel ID="pnTTCaoTrang" runat="server" Visible="false">
                                            <tr>
                                                <td>Ngày bản cáo trạng<span class="batbuoc">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtThuLy_NgayCaoTrang" runat="server" CssClass="user" Width="100px"
                                                        MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtThuLy_NgayCaoTrang" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtThuLy_NgayCaoTrang" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Số bản cáo trạng<span class="batbuoc">(*)</span></td>
                                                <td>
                                                    <asp:TextBox ID="txtThuLy_SoCaoTrang" runat="server" CssClass="user align_right"
                                                        Width="100px"></asp:TextBox>
                                                </td>

                                            </tr>
                                        </asp:Panel>
                                        <tr style="display: none">
                                            <td>Từ ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px"
                                                    MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay"
                                                    Format="dd/MM/yyyy" Enabled="false" />
                                                <cc1:MaskedEditExtender ID="txtTuNgay_MaskedEditExtender" runat="server" TargetControlID="txtTuNgay"
                                                    Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td>Đến ngày</td>
                                            <td>
                                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px"
                                                    MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server"
                                                    TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server"
                                                    TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN"
                                                    ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-------------------------------->
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                    </div>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; margin-bottom: 100px;">
                    <asp:Button ID="cmdUpdateVuAnB" runat="server" CssClass="buttoninput"
                        Text="Lưu" OnClientClick="return validate_all();" OnClick="cmdUpdateVuAn_Click" />
                    <asp:Button ID="cmdUpdateSelectB" runat="server" CssClass="buttoninput"
                        Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" CssClass="buttoninput"
                        Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click"
                        OnClientClick="return validate_all();" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput"
                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
            </div>
        </div>
    </div>
    <div style="display: none">
        <asp:Button ID="cmdLoadDsBiDonKhac" runat="server"
            Text="Load ds BI don khac" OnClick="cmdLoadDsBiDonKhac_Click" />
        <asp:Button ID="cmdLoadDsNguoiTGTT" runat="server"
            Text="Load ds nguoi TGTT" OnClick="cmdLoadDsNguoiTGTT_Click" />
    </div>
    <script>
        function LoadDsBiCan() {
            // alert('goi load ds bi can + toi danh bi can dau vu');
            $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
        }
        function LoadDsNguoiThamGiaTT() {
            //alert('ds nguoi tham gia tt form parent');
            $("#<%= cmdLoadDsNguoiTGTT.ClientID %>").click();
        }
    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
            $("[id$=txtTamtru]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddTamtruID]").val(i.item.val); }, minLength: 1
            });
            //----------------
            $("[id$=txtHKTT]").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                    });
                },
                select: function (e, i) { $("[id$=hddHKTTID]").val(i.item.val); }, minLength: 1
            });
            //-----------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


    <script>
        function validate() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            return true;
        }
        function validate_all() {
            if (!validate_thongtinhoso())
                return false;
            //---------------------
            if (!validate_thongtin_vuan())
                return false;
            //---------------------
            if (!validate_thuly())
                return false;
            return true;
        }

        function validate_thongtinhoso() {
            var dropTrangThaiGiaoNhan = document.getElementById('<%=dropTrangThaiGiaoNhan.ClientID%>');
            var value_change = dropTrangThaiGiaoNhan.options[dropTrangThaiGiaoNhan.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn trường hợp giao nhận. Hãy kiểm tra lại!');
                dropTrangThaiGiaoNhan.focus();
                return false;
            }

            //-----------------------------
            var txtSoBanCaoTrang = document.getElementById('<%=txtSoBanCaoTrang.ClientID%>');
            if (!Common_CheckEmpty(txtSoBanCaoTrang.value)) {
                alert('Bạn chưa nhập số bản cáo trạng.Hãy kiểm tra lại!');
                txtSoBanCaoTrang.focus();
                return false;
            }
            //-----------------------------
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanCaoTrang, 'Ngày bản cáo trạng'))
                return false;

            //-----------------------------
            var txtSoButLuc = document.getElementById('<%=txtSoButLuc.ClientID%>');
            if (!Common_CheckEmpty(txtSoButLuc.value)) {
                alert('Bạn chưa nhập số bút lục.Hãy kiểm tra lại!');
                txtSoButLuc.focus();
                return false;
            }

            //-----------------------------
            var txtNgayGiao = document.getElementById('<%=txtNgayGiao.ClientID%>');
            if (!CheckDateTimeControl(txtNgayGiao, 'Ngày giao bút lục'))
                return false;
            //-----------------------------
            var txtTenVuAn = document.getElementById('<%=txtTenVuAn.ClientID%>');
            if (!Common_CheckEmpty(txtTenVuAn.value)) {
                alert('Bạn chưa nhập tên vụ án!');
                txtTenVuAn.focus();
                return false;
            }
            return true;
        }

        function validate_thongtin_vuan() {
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBanCaoTrang, 'Ngày bản cáo trạng'))
                return false;

            <%--var txtNgayXayra = document.getElementById('<%=txtNgayXayra.ClientID%>');
            if (!CheckDateTimeControl(txtNgayXayra, 'Ngày xảy ra vụ án'))
                return false;--%>

            if (!SoSanh2Date(txtNgayBanCaoTrang, 'Ngày bản cáo trạng', txtNgayXayra.value, 'Ngày xảy ra vụ án')) {
                txtNgayXayra.focus();
                return false;
            }
            return true;
        }

        function Set_Date_NgayGiaoHS() {
            var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
            var txtNgayGiao = document.getElementById('<%=txtNgayGiao.ClientID%>');

            var Empty_date = '__/__/____';
            if ((Common_CheckEmpty(txtNgayBanCaoTrang.value)) && (txtNgayBanCaoTrang.value != Empty_date))
                txtNgayGiao.value = txtNgayBanCaoTrang.value;
        }

        function validate_thuly() {
            var rdThuLy = document.getElementById('<%=rdThuLy.ClientID%>');
            msg = 'Mục "Thụ lý vụ việc" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdThuLy, msg))
                return false;
            var selected_value = GetStatusRadioButtonList(rdThuLy);
            if (selected_value == 1) {
                var ddTruongHopTL = document.getElementById('<%=ddTruongHopTL.ClientID%>');
                value_change = ddTruongHopTL.options[ddTruongHopTL.selectedIndex].value;
                if (value_change == "") {
                    alert('Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!');
                    ddTruongHopTL.focus();
                    return false;
                }

                //-----------------------------
                var txtNgayBanCaoTrang = document.getElementById('<%=txtNgayBanCaoTrang.ClientID%>');
                var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
                if (!CheckDateTimeControl(txtNgayThuLy, 'Ngày thụ lý'))
                    return false;

                //-----------------------------
                if (value_change == "233") {
                    var temp_length = "";
                    var txtThuLy_SoCaoTrang = document.getElementById('<%=txtThuLy_SoCaoTrang.ClientID%>');
                    if (!Common_CheckEmpty(txtThuLy_SoCaoTrang.value)) {
                        alert('Bạn chưa nhập số bản cáo trạng khi thụ lý.Hãy kiểm tra lại!');
                        txtThuLy_SoCaoTrang.focus();
                        return false;
                    }
                    else {
                        temp_length = txtThuLy_SoCaoTrang.value.length;
                        if (temp_length > 250) {
                            alert('Số bản cáo trạng không quá 250 ký tự. Hãy kiểm tra lại!');
                            txtThuLy_SoCaoTrang.focus();
                            return false;
                        }
                    }

                    //----------------------------
                    var txtThuLy_NgayCaoTrang = document.getElementById('<%=txtThuLy_NgayCaoTrang.ClientID%>');
                    if (!CheckDateTimeControl(txtThuLy_NgayCaoTrang, 'Ngày bản cáo trạng khi thụ lý'))
                        return false;
                }
            }
            return true;
        }
    </script>
    <script>
        function popup_them_bc(VuAnID) {
            var link = "/QLAN/AHS/Hoso/popup/pBiCao.aspx?hsID=" + VuAnID;
            var width = screen.availWidth;
            var height = 1000;
            PopupCenter(link, "Cập nhật thông tin bị can", width, height);
        }
        function popup_them_NguoiTGTT(VuAnID) {
            var link = "/QLAN/AHS/Hoso/Popup/pNguoiThamGiaTT.aspx?hsID=" + VuAnID;
            var width = 850;
            var height = 650;
            PopupCenter(link, "Người tham gia đối tượng", width, height);
        }
        function popupCaoTrang() {
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pCaoTrang.aspx?hsID=" + hddVuAnID.value
            var width = 950;
            var height = 550;
            PopupCenter(link, "Cáo trạng", width, height);
        }
        function popupDieuLuatAD() {
            var width = 950;
            var height = 550;
            var hddCaoTrangID = document.getElementById('<%=hddCaoTrangID.ClientID%>');
            var hddVuAnID = document.getElementById('<%=hddID.ClientID%>');
            var hddBiCaoID = document.getElementById('<%=hddBiCaoID.ClientID%>');
            var link = "/QLAN/AHS/Hoso/popup/pChonToiDanh.aspx?hsID=" + hddVuAnID.value + "&bID=" + hddBiCaoID.value;
            PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>

</asp:Content>



