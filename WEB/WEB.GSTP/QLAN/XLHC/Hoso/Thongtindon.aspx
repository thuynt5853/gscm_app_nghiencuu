<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Thongtindon.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Hoso.Thongtindon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddToaanId" runat="server" Value="0" />
     <asp:HiddenField ID="hddToaAnGiaiQuyetId" runat="server" Value="0" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" OnClientClick="return validate();" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelect" runat="server" CssClass="buttoninput" OnClientClick="return validate();" Text="Lưu & Chọn xử lý" OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNew" runat="server" CssClass="buttoninput" OnClientClick="return validate();" Text="Lưu & Thêm mới" OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>
                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin vụ việc</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr style="display: none;">
                                <td style="width: 125px;">Mã vụ việc</td>
                                <td style="width: 250px;">
                                    <asp:TextBox ID="txtMaVuViec" CssClass="user"
                                        placeholder="Mã vụ việc tự sinh" ReadOnly="true"
                                        runat="server" Width="98%" MaxLength="50" Enabled="false"></asp:TextBox></td>
                                <td style="width: 115px;">Tên vụ việc</td>
                                <td>
                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" placeholder="Tên vụ việc tự sinh"
                                        ReadOnly="true" runat="server" Width="98%" TextMode="MultiLine" Rows="2" Height="40px" Enabled="false"></asp:TextBox></td>
                            </tr>
                            <tr>

                                <td style="width: 130px;">Ngày nhận<span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayNhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <%--<td style="width: 120px;">Loại đơn</td>
                                <td>
                                    <asp:DropDownList ID="ddlLoaidon" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Đơn mới"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Đơn từ Tòa án khác chuyển đến"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Đơn trùng"></asp:ListItem>
                                        <asp:ListItem Value="4" Text="Đơn không thuộc thẩm quyền"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>--%>
                              <td style="width: 120px;">Hình thức nhận</td>
                                <td>
                                    <asp:DropDownList ID="ddlHinhthucnhandon" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Trực tiếp"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Qua bưu điện"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Trực tuyến"></asp:ListItem>
                                    </asp:DropDownList></td>
                                <td></td>
                                <td></td>
                            </tr>

                            <tr>
                                <td>Cán bộ nhận<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlCanbonhandon" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                     <asp:DropDownList ID="ddlOldCanbonhandon" CssClass="chosen-select" runat="server" Width="250px" Enabled="false">
                                    </asp:DropDownList>
                                </td>
                                <td>Thẩm phán ký nhận đơn</td>
                                <td>
                                    <div>
                                        <asp:DropDownList ID="ddlThamphankynhandon" CssClass="chosen-select" runat="server" Width="250px" OnSelectedIndexChanged="ddlThamphankynhandon_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                    <div>
                                        <asp:DropDownList ID="ddlOldThamphankynhandon" CssClass="chosen-select" runat="server" Width="250px" Enabled="false"></asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>Nội dung đơn</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoidungkhoikien" CssClass="user" runat="server" Width="99%" TextMode="MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Literal ID="lstTitleNguyendon" runat="server" Text="Thông tin cơ quan đề nghị"></asp:Literal>
                    </h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td>Tên cơ quan đề nghị<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtTennguyendon" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>


                            </tr>
                            <tr>
                                <td>Ngày đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayViet" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayViet" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayViet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayViet" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td>Biện pháp đề nghị<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>

                            </tr>
                            <tr>
                                <td>Địa chỉ<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlTinh_CQDN" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTinh_CQDN_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:DropDownList ID="ddlHuyen_CQDN" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                </td>
                                <td>Chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtDiachichitiet_CQDN" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 130px;">Email</td>
                                <td style="width: 260px;">
                                    <asp:TextBox ID="txtND_Email" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td style="width: 120px;">Điện thoại</td>
                                <td>
                                    <asp:TextBox ID="txtND_Dienthoai" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                    Fax
                                    <asp:TextBox ID="txtND_Fax" runat="server" CssClass="user" Width="103px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Người đại diện</td>
                                <td>
                                    <asp:TextBox ID="txtND_NDD_Ten" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Chức vụ</td>
                                <td>
                                    <asp:TextBox ID="txtND_NDD_Chucvu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">
                        <asp:Literal ID="lstTitleBidon" runat="server" Text="Thông tin người bị đề nghị"></asp:Literal></h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 130px;">Họ tên<span class="batbuoc">(*)</span></td>
                                <td style="width: 260px;">
                                    <asp:TextBox ID="txtTenBiCan" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                                <td style="width: 120px;">Tên khác</td>
                                <td>
                                    <asp:TextBox ID="txtTenKhac" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Giới tính</td>
                                <td>
                                    <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server" Width="250px">
                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList></td>
                                <td>Ngày sinh</td>
                                <td>
                                    <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user" Width="100px" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <asp:TextBox ID="txtNamSinh" Visible="false" runat="server" CssClass="user" Width="70px" MaxLength="10" placeholder="Năm sinh"></asp:TextBox>
                                    Tuổi<span class="batbuoc">(*)</span>
                                    <asp:TextBox ID="txtND_Tuoi" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Số định danh cá nhân<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtIdSoDinhDanhCaNhan" CssClass="user" runat="server" Width="242px" MaxLength="12"></asp:TextBox>
                                </td>
                                <td>Có số định danh cá nhân<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rblChonNguonThongTin" runat="server"
                                        RepeatDirection="Horizontal"
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="rblChonNguonThongTin_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Selected="True">Có</asp:ListItem>
                                        <asp:ListItem Value="0" >Không</asp:ListItem>
                                        
                                    </asp:RadioButtonList>

                                </td>
                            </tr>

                            <tr>
                                <td>Hộ chiếu</td>
                                <td>
                                    <asp:TextBox ID="txtIdHoChieu" CssClass="user" runat="server" Width="242px" MaxLength="12"></asp:TextBox>
                                </td>
                                <td>Dân tộc<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropDanToc" CssClass="chosen-select"
                                        runat="server" Width="250px">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td>Thường trú<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlThuongTru_Tinh" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlThuongTru_Tinh_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:DropDownList ID="ddlThuongTru_Huyen" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                </td>
                                <td>Chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtHKTT_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Nơi sinh sống<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlTamTru_Tinh" CssClass="chosen-select" runat="server" Width="123px" AutoPostBack="true" OnSelectedIndexChanged="ddlTamTru_Tinh_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:DropDownList ID="ddlTamTru_Huyen" CssClass="chosen-select" runat="server" Width="123px"></asp:DropDownList>
                                </td>
                                <td>Chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtTamtru_Chitiet" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Tôn giáo</td>
                                <td>
                                    <asp:DropDownList ID="dropTonGiao" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList></td>
                                <td>Nghề nghiệp</td>
                                <td>
                                    <asp:DropDownList ID="dropNgheNghiep" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList></td>
                            </tr>

                            <tr>
                                <td>Trình độ văn hóa<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropTrinhDoVH" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList></td>

                                <%--<td>Tình trạng giam giữ</td>
                                <td>
                                    <asp:DropDownList ID="dropTinhTrangGiamGiu" CssClass="chosen-select" runat="server" Width="250px">
                                    </asp:DropDownList>
                                </td>--%>
                            </tr>

                            <tr>
                                <td colspan="4" style="height: 5px;"></td>
                            </tr>
                            <tr id="row_thongtinbo">
                                <td>Họ tên bố</td>
                                <td>
                                    <asp:TextBox ID="txtHoTenBo" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Năm sinh</td>
                                <td>
                                    <asp:TextBox ID="txtNamSinhBo" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="100px" MaxLength="50"></asp:TextBox></td>
                            </tr>
                            <tr id="row_thongtinme">
                                <td>Họ tên mẹ</td>
                                <td>
                                    <asp:TextBox ID="txtHotenMe" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                <td>Năm sinh</td>
                                <td>
                                    <asp:TextBox ID="txtNamSinhMe" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="100px" MaxLength="50"></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td>Nghiện hút<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdNGhienHut" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td>Tái phạm<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:RadioButtonList ID="rdTinhTrangTaiPham" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tiền án</td>
                                <td>
                                    <asp:TextBox ID="txtTienAn" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="242px" MaxLength="50" Text="0"></asp:TextBox></td>
                                <td>Tiền sự</td>
                                <td>
                                    <asp:TextBox ID="txtTienSu" CssClass="user align_right"
                                        onkeypress="return isNumber(event)" runat="server"
                                        Width="242px" MaxLength="50" Text="0"></asp:TextBox></td>
                            </tr>
                            <!---------------------------------------------->
                            <tr>
                                <td>Trẻ vị thành niên<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdTreViThanhNien" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdTreViThanhNien_SelectedIndexChanged">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList></td>
                            </tr>
                            <asp:Panel ID="pnTreViThanhNien" runat="server" Visible="false">
                                <tr>
                                    <td>Trẻ mồ côi cha hoặc mẹ<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdTreMoCoi" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td style="text-align: right;">Trẻ lang thang<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdTreLangThang" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Trẻ bỏ học<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdTreBoHoc" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td style="text-align: right;">Bố mẹ ly hôn<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdLyHon" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Có người đủ 18 tuổi trở lên xúi giục<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdNguoiXuiGiuc" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </asp:Panel>
                        </table>
                    </div>
                </div>


                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdUpdateB" runat="server" OnClientClick="return validate();" CssClass="buttoninput" Text="Lưu" OnClick="cmdUpdate_Click" />
                    <asp:Button ID="cmdUpdateSelectB" runat="server" OnClientClick="return validate();" CssClass="buttoninput" Text="Lưu & Chọn xử lý"
                        OnClick="cmdUpdateSelect_Click" />
                    <asp:Button ID="cmdUpdateAndNewB" runat="server" OnClientClick="return validate();" CssClass="buttoninput" Text="Lưu & Thêm mới"
                        OnClick="cmdUpdateAndNew_Click" />
                    <asp:Button ID="cmdQuaylaiB" runat="server" CssClass="buttoninput" Text="Quay lại"
                        OnClick="cmdQuaylai_Click" />

                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
       // function isNumberKey(evt) {
        //        var charCode = evt.which || evt.keyCode;
            //    if (charCode < 48 || charCode > 57) return false;
          //      return true;
           // }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }     
        function validate() {
            var msg = "";         
            var rdNGhienHut = document.getElementById('<%=rdNGhienHut.ClientID%>');
                    msg = 'Mục "Nghiện hút"  bắt buộc phải chọn.';
                    msg += 'Hãy kiểm tra lại!';
                    if (!CheckChangeRadioButtonList(rdNGhienHut, msg)) {
                        rdNGhienHut.focus();
                        return false;
                    }
                    //----------------------------
                    var rdTinhTrangTaiPham = document.getElementById('<%=rdTinhTrangTaiPham.ClientID%>');
                    msg = 'Mục "Tái phạm, tái phạm nguy hiểm"  bắt buộc phải chọn.';
                    msg += 'Hãy kiểm tra lại!';
                    if (!CheckChangeRadioButtonList(rdTinhTrangTaiPham, msg))
                    {
                        rdTinhTrangTaiPham.focus();
                        return false;
                    }
                    //----------------------------
                    var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
                    msg = 'Mục "Trẻ vị thành niên" bắt buộc phải chọn.';
                    msg += 'Hãy kiểm tra lại!';
                    if (!CheckChangeRadioButtonList(rdTreViThanhNien, msg))
                    {
                        rdTreViThanhNien.focus();
                        return false;
                    }
                    else {
                        var selected_value = GetStatusRadioButtonList(rdTreViThanhNien);
                        if (selected_value == 1) {
                            if (!validate_trevithanhnien())
                                return false;
                        }
                    }
                    return true;
         }
         function validate_trevithanhnien() {          
            var rdTreMoCoi = document.getElementById('<%=rdTreMoCoi.ClientID%>');
            msg = 'Mục "Trẻ mồ côi cha hoặc mẹ" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreMoCoi, msg))
            {
                rdTreMoCoi.focus();
                return false;
            }
            //----------------------------
            //msg = 'Mục "" bắt buộc phải chọn.';
            var rdTreLangThang = document.getElementById('<%=rdTreLangThang.ClientID%>');
            msg = 'Mục "Trẻ lang thang" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreLangThang, msg))
            {
                rdTreLangThang.focus();
                return false;
            }
            //----------------------------
            var rdTreBoHoc = document.getElementById('<%=rdTreBoHoc.ClientID%>');
            msg = 'Mục "Trẻ bỏ học" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreBoHoc, msg))
            {
                rdTreBoHoc.focus();
                return false;
            }

            //----------------------------
            var rdLyHon = document.getElementById('<%=rdLyHon.ClientID%>');
            msg = 'Mục "Bố mẹ ly hôn" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdLyHon, msg))
            {
                rdLyHon.focus();
                return false;
            }

            //----------------------------
            var rdNguoiXuiGiuc = document.getElementById('<%=rdNguoiXuiGiuc.ClientID%>');
            msg = 'Mục "Có người đủ 18 tuổi trở lên xúi giục" bắt buộc phải chọn.';
            msg += 'Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdNguoiXuiGiuc, msg))
            {
                rdNguoiXuiGiuc.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
