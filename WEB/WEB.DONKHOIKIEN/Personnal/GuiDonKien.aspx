<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true"
    CodeBehind="GuiDonKien.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.GuiDonKien" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Personnal/Thongtinnguoiuyquyen.ascx" TagPrefix="uc2" TagName="Thongtinnguoiuyquyen" %>
<%@ Register Src="~/Personnal/UC/Help.ascx" TagPrefix="uc1" TagName="Help" %>
<%@ Register Src="~/UserControl/MenuDon.ascx" TagPrefix="uc1" TagName="MenuDon" %>
<%@ Register Src="~/UserControl/HuongDan.ascx" TagPrefix="uc1" TagName="HuongDan" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        .content_right {
            position: relative;
        }

        .label_form {
            float: left;
            font-weight: bold;
            margin-bottom: 3px;
            margin-right: 5px;
            line-height: 28px;
        }

        .boder {
            padding: 10px 2.5%;
            float: left;
            width: 95%;
        }

        .table1 tr, td {
            padding-left: 0px;
            padding-bottom: 7px;
        }

        .margin_cell_right {
            float: right;
            margin-right: 16px;
        }

        .margin_cell_right2 {
            float: right;
            margin-right: 12px;
        }

        .bg_vang {
            background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%) repeat scroll 0 0;
            padding: 0px 20px;
            margin-top: 10px;
        }

        .dangky_UyQuyen {
            float: left;
            padding-top: 15px;
            margin: 0px;
        }

        .float_left {
            float: left;
        }

        .float_right {
            margin-right: 15px;
        }

        .title_ds_duongsu {
            float: left;
            width: 100%;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .xsize{
            width:16px;
        }
        .border_bottom_textbox {
            border: none;
            border-bottom: dashed 1px #c5c5c5;
            padding: 8px 0px 2px 0px;
        }

        .batbuoc {
            margin-left: 2px;
        }
        .hidebtn
        {
            display:none;
        }
    </style>

    <div class="content_center">
        <div class="content_form">
            <div class="hosoleft">
                <uc1:MenuDon runat="server" ID="MenuDon" />
                <uc1:HuongDan runat="server" ID="HuongDan" />
                <%-- <uc1:DKNhanVB runat="server" ID="DKNhanVB" />--%>
            </div>
            <div class="hosoright">
                <div class="guidonkien">

                    <asp:Literal ID="ltt" runat="server"></asp:Literal>
                    <!--------------------------->
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                            <asp:Panel ID="pnDonKien" runat="server">
                                <asp:HiddenField ID="hddIsNew" runat="server" Value="1" />
                                <asp:HiddenField ID="hddStatus" runat="server" />
                                <asp:HiddenField ID="hddLinhVucVuViec" runat="server" Value="AN_DANSU" />
                                <asp:HiddenField ID="hddGSTP_MaVuViec" runat="server" Value="" />
                                <asp:HiddenField ID="hddDonKKID" runat="server" Value="0" />
                                <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
                                <asp:HiddenField ID="hddStatusDonKK" runat="server" Value="0" />
                                <asp:HiddenField ID="hddShowPopup" runat="server" Value="0" />


                                <div class="right_full_width distance_bottom">
                                    <div style="box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2); width: 100%; float: left;">
                                        <div class="right_full_width_head">
                                            <a href="javascript:;" class="dowload_head">Thông tin đơn khởi kiện</a>
                                            <div class="dangky_head_right">
                                                <uc1:Help runat="server" ID="Help" />
                                            </div>
                                        </div>
                                        <div class="content_right">
                                            <div id="zone_message"></div>

                                            <!------------------------------------------->
                                            <div class="right_full_width head_title_center">
                                                <span>Cộng hòa xã hội chủ nghĩa Việt nam</span>
                                            </div>
                                            <div class="right_full_width head_title_center" style="margin-bottom: 15px;">
                                                <span style="text-transform: none;">Độc lập - Tự do - Hạnh phúc</span>
                                                <span style="border-bottom: solid 1px gray; width: 24%; float: left; margin-left: 38%; margin-top: 5px;"></span>
                                            </div>
                                            <!------------------------------>

                                            <div class="right_full_width head_title_center">
                                                <span style="font-size: 15pt;">Đơn khởi kiện</span>
                                            </div>
                                            <!--------cac drop ko hien ra ngoai------------->
                                            <div style="display: none;">
                                                <asp:DropDownList ID="ddlLoaiQuanhe"
                                                    runat="server" Width="50%">
                                                    <asp:ListItem Value="1" Text="Tranh chấp"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Yêu cầu"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <!-----end---------->

                                            <!---------------------->
                                            <div style="float: left; font-weight: bold; text-align: center; width: 100%;">
                                                <table class="table1" style="width: 99%;">
                                                    <tr>
                                                        <td style="width: 130px;">Kính gửi  <span class="batbuoc">*</span></td>
                                                        <td>
                                                            <div style="float: left; width: 100%; text-align: left; margin-left: 5px">
                                                                <asp:HiddenField ID="hddToaAnID" runat="server" />
                                                                <%--<asp:TextBox ID="txtToaAn" CssClass="textbox" runat="server"
                                                                    Width="572px" placeholder="(Gõ tên Tòa án vào đây để tìm kiếm và lựa chọn Tòa án để gửi đơn)"
                                                                    AutoCompleteType="Search"></asp:TextBox>--%>

                                                                    <asp:DropDownList ID="ddlToaanID" CssClass="chosen-select" runat="server" Width="666px"></asp:DropDownList>

                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%--<tr>
                                <td></td>
                                <td><i style="float: left; width: 100%; font-weight: normal; margin-top: 3px;"></i>
                                </td>
                            </tr>--%>
                                                </table>
                                            </div>
                                            <div class="right_full_width">
                                                <%-- <div class="fullwidth">
                            <asp:Literal ID="lttThongBaoTop" runat="server"></asp:Literal>
                        </div>--%>
                                                <!---------------------->
                                                <div style="float: left; color: red; margin-top: 5px; font-weight: bold; font-size: 13px;">
                                                    <asp:Literal ID="lttMsgTop"
                                                        runat="server"></asp:Literal>
                                                </div>
                                                <div class="msg_warning" style="float: right; font-style: italic; margin-top: 0px">
                                                    Những thông tin có dấu <span class="batbuoc">*</span>  là phần bắt buộc
                                                </div>
                                                <div class="boxchung" style="margin-top: 0px;">
                                                    <div class="boder bg_vang" style="">
                                                        <div style="float: left; width: 150px; line-height: 40px">Khởi kiện về lĩnh vực</div>
                                                        <div style="float: left;">
                                                            <asp:RadioButtonList ID="rdLoaiAn"
                                                                AutoPostBack="true" OnSelectedIndexChanged="rdLoaiAn_SelectedIndexChanged"
                                                                CssClass="dangky_UyQuyen" runat="server" RepeatDirection="Horizontal">
                                                                <asp:ListItem Value="AN_DANSU" Selected="True"><span style="font-weight:bold; font-size:12pt;">Dân sự(DS, HNGD, LD, KDTM)</span></asp:ListItem>
                                                                <asp:ListItem Value="AN_HANHCHINH"><span  style="font-weight:bold; font-size:12pt;">Hành chính</span></asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="boxchung">
                                                    <h4 class="tleboxchung">
                                                        <asp:Literal ID="lstTitleNguyendon" runat="server"
                                                            Text="Thông tin người khởi kiện"></asp:Literal>
                                                    </h4>
                                                    <div class="boder">
                                                        <table class="table1" cell-padding="2px">
                                                            <tr>
                                                                <td style="width: 115px;">Có ủy quyền</td>
                                                                <td colspan="3">
                                                                    <asp:RadioButtonList ID="rdUyQuyen"
                                                                        AutoPostBack="true" OnSelectedIndexChanged="rdUyQuyen_SelectedIndexChanged"
                                                                        CssClass="dangky_UyQuyen" runat="server" RepeatDirection="Horizontal">
                                                                        <asp:ListItem Value="1" Selected="True"><span>Không</span></asp:ListItem>
                                                                        <asp:ListItem Value="2"><span>Có</span></asp:ListItem>
                                                                    </asp:RadioButtonList></td>
                                                            </tr>

                                                            <tr>
                                                                <td>Người khởi kiện là<span class="batbuoc">*</span></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlLoaiNguyendon"
                                                                        AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged"
                                                                        CssClass="chosen-select" runat="server" Width="180px">
                                                                        <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                                        <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                                        <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                                <td style="width: 90px;">
                                                                    <asp:Label ID="lblND_HoTen" runat="server" Text="Họ tên"></asp:Label>
                                                                    <span class="batbuoc">*</span></td>
                                                                <td>
                                                                    <asp:TextBox ID="txtTennguyendon" CssClass="textbox"
                                                                        runat="server" Width="295"></asp:TextBox></td>
                                                            </tr>

                                                            <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                                                <tr>
                                                                    <td>Địa chỉ<span class="batbuoc">*</span></td>
                                                                    <td>
                                                                        <asp:DropDownList ID="dropToChuc_Tinh" runat="server"
                                                                            AutoPostBack="true" OnSelectedIndexChanged="dropToChuc_Tinh_SelectedIndexChanged"
                                                                            CssClass="chosen-select" placeholder="---Tỉnh/TP---" Width="180px">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td>Quận/Huyện<span class="batbuoc">*</span></td>
                                                                    <td>
                                                                        <asp:DropDownList ID="dropToChuc_QuanHuyen" runat="server" Width="309px"
                                                                            CssClass="chosen-select" placeholder="---Quận/Huyện---">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Địa chỉ chi tiết<span class="batbuoc">*</span></td>
                                                                    <td colspan="3">
                                                                        <asp:TextBox ID="txtToChuc_DiaChiCT" CssClass="textbox" placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                                            runat="server" Width="585px"></asp:TextBox></td>
                                                                </tr>
                                                                <!---------------------------------------->
                                                                <tr>
                                                                    <td>Người đại diện<span class="batbuoc">*</span></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtToChuc_NguoiDD" CssClass="textbox"
                                                                            runat="server" Width="165px" MaxLength="250"></asp:TextBox></td>
                                                                    <td>Chức vụ</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtToChuc_NguoiDD_ChucVu" CssClass="textbox"
                                                                            runat="server" Width="295px" MaxLength="250"></asp:TextBox></td>
                                                                </tr>
                                                            </asp:Panel>
                                                            <tr>
                                                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu<span class="batbuoc">*</span></td>
                                                                <td>
                                                                    <asp:TextBox ID="txtND_CMND" CssClass="textbox" runat="server"
                                                                        Width="165px" MaxLength="250"></asp:TextBox></td>
                                                                <td>Giới tính</td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlND_Gioitinh"
                                                                        CssClass="chosen-select" runat="server" Width="309px">
                                                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>

                                                            <asp:Panel ID="pnNDCanhan" runat="server">
                                                                <tr>
                                                                    <td>Quốc tịch<span class="batbuoc">*</span></td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlND_Quoctich" CssClass="chosen-select"
                                                                            runat="server" Width="180px" AutoPostBack="True"
                                                                            OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged">
                                                                        </asp:DropDownList></td>
                                                                    <td>Ngày sinh</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtND_Ngaysinh" runat="server"
                                                                            CssClass="textbox" Width="70px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                        <div style="float: right; line-height: 30px; margin-right: 15px;">
                                                                            <span>Năm sinh</span>
                                                                            <span class="batbuoc" style='margin-right: 5px;'>*</span>
                                                                            <asp:TextBox ID="txtND_Namsinh" CssClass="textbox margin_cell_right"
                                                                                onkeypress="return isNumber(event)" runat="server"
                                                                                AutoPostBack="true" OnTextChanged="txtND_Namsinh_TextChanged"
                                                                                Width="90px" MaxLength="4"></asp:TextBox>
                                                                        </div>

                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td></td>
                                                                    <td colspan="3">
                                                                        <%-- <div class="checkboxFive">
                                                    <input type="checkbox" value="1" id="checkboxFiveInput" name="" />
                                                    <label for="checkboxFiveInput"></label>
                                                </div>--%>
                                                                        <asp:CheckBox ID="chkND_ONuocNgoai" AutoPostBack="true" OnCheckedChanged="chkND_CheckedChanged"
                                                                            runat="server" Text=" Quốc tịch Việt Nam nhưng sinh sống ở nước ngoài" />

                                                                    </td>
                                                                </tr>
                                                                
                                                                <!---------------------------------------->
                                                                <asp:Panel ID="pnNguyenDon_HK" runat="server">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Literal ID="lblND_NoiCuTruLabel" runat="server" Text="Nơi cư trú"></asp:Literal>
                                                                            <asp:Literal ID="lblND_Tinh" runat="server">
                                                        <span class="batbuoc">*</span></asp:Literal>
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="dropTinh_TamTru" runat="server"
                                                                                AutoPostBack="true" OnSelectedIndexChanged="dropTinh_TamTru_SelectedIndexChanged"
                                                                                CssClass="chosen-select" placeholder="Tỉnh" Width="180px">
                                                                            </asp:DropDownList></td>
                                                                        <td>
                                                                            <asp:Literal ID="lblND_HuyenLabel" runat="server" Text="Quận/Huyện"></asp:Literal>
                                                                            <asp:Literal ID="lblND_Huyen" runat="server">
                                                    <span class="batbuoc">*</span></asp:Literal></td>
                                                                        <td>
                                                                            <asp:DropDownList ID="dropQuanHuyen_TamTru"
                                                                                runat="server" Width="309px"
                                                                                CssClass="chosen-select" placeholder="Tỉnh">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Địa chỉ chi tiết
                                                     <span class="batbuoc" id="labelND_tamtru_diachi_chitiet">*</span>
                                                                        </td>
                                                                        <td colspan="3">
                                                                            <asp:TextBox ID="txtND_TTChitiet" CssClass="textbox"
                                                                                placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                                                runat="server" Width="585px"></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="3"><i class='warning_dc'>(Địa chỉ này dùng để nhận các văn bản, thông báo từ Tòa án)</i></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Nơi làm việc</td>
                                                                        <td colspan="3">
                                                                            <asp:TextBox ID="txtND_DiaChiCoQuan" CssClass="textbox"
                                                                                runat="server" Width="585px"></asp:TextBox></td>
                                                                    </tr>
                                                                </asp:Panel>
                                                                <!---------------------------------------->
                                                            </asp:Panel>
                                                            <tr>
                                                                <td>Email<span class="batbuoc">*</span></td>
                                                                <td>
                                                                    <asp:TextBox ID="txtND_Email" CssClass="textbox" Enabled="false"
                                                                        runat="server" Width="165px" MaxLength="250"></asp:TextBox></td>
                                                                <td>Điện thoại</td>
                                                                <td>
                                                                    <asp:TextBox ID="txtND_Dienthoai" runat="server" onkeypress="return isNumber(event)"
                                                                        CssClass="textbox" Width="90px"></asp:TextBox>
                                                                    <div style="float: right; line-height: 30px; margin-right: 15px;">
                                                                        <span style="float: left; margin-right: 10px">Fax</span>
                                                                        <asp:TextBox ID="txtND_Fax" runat="server" onkeypress="return isNumber(event)"
                                                                            CssClass="textbox align_right margin_cell_right" Width="90px"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Panel ID="pnUyQuyen" runat="server" Visible="false">
                                                                        <a id="lkThemUyQuyen" href="javascript:"
                                                                            class="link_them_duongsu align_left them_user"
                                                                            onclick="show_popup_by_loaidsNguoiuyquyen('<%=NGUOIUYQUYEN %>')">Thêm thông tin người ủy quyền</a>
                                                                    </asp:Panel>
                                                                </td>
                                                                <td colspan="2">
                                                                    <asp:Panel ID="pnThemNguoiKhoiKienKhac" runat="server" Visible="true">
                                                                        <a href="javascript:" id="lkThemND" style="margin-right: 30px;"
                                                                            class="link_them_duongsu float_right align_right them_user"
                                                                            onclick="show_popup_by_loaids('<%=NGUYENDON %>')">Thêm người khởi kiện khác</a>
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                            
                                                        </table>
                                                        <div style="margin: 5px; width: 99%;">
                                                                    <uc2:Thongtinnguoiuyquyen runat="server" ID="Thongtinnguoiuyquyen" />
                                                                </div>
                                                        <div style="float: left; width: 100%">
                                                            <div style="display: none">
                                                                <asp:Button ID="cmdLoadDsNguyenDonKhac" runat="server"
                                                                    Text="Load ds nguyen don khac" OnClick="cmdLoadDsNguyenDonKhac_Click" />
                                                            </div>

                                                            <asp:Literal ID="lttDsNguyenDonKhacTitle"
                                                                runat="server" Visible="false"></asp:Literal>
                                                            <div style="float: right;" class="msg_thongbao">
                                                                <asp:Literal ID="lttMsgNguyenDon"
                                                                    runat="server" Visible="false"></asp:Literal>
                                                            </div>
                                                            <asp:Repeater ID="rptNguyenDonKhac" runat="server"
                                                                OnItemCommand="rptNguyenDonKhac_ItemCommand">
                                                                <HeaderTemplate>
                                                                    <div class="CSSTableGenerator">
                                                                        <table>
                                                                            <tr id="row_header">
                                                                                <td style="width: 20px;">TT</td>
                                                                                <td>Họ và tên</td>
                                                                                <td>Nơi cư trú hiện tại</td>
                                                                                <td style="width: 70px;">Thao tác</td>
                                                                            </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td><%# Container.ItemIndex + 1 %>
                                                                            <asp:HiddenField ID="hddDuongSuID" runat="server" Value=' <%#Eval("ID") %>' />
                                                                        </td>
                                                                        <td>
                                                                            <div style="text-align: justify; float: left;"><%#Eval("TENDUONGSU") %></div>
                                                                        </td>

                                                                        <td><%#Eval("TamTruChiTiet") %></td>
                                                                        <td>
                                                                            <div style="text-align: center;">
                                                                                <asp:ImageButton ID="imgXoa" CssClass="xsize" runat="server" ImageUrl="/UI/img/delete.png"
                                                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:ImageButton>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                                <FooterTemplate></table></div></FooterTemplate>
                                                            </asp:Repeater>

                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="guidon">
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung">
                                                            <asp:Literal ID="lstTitleBidon" runat="server" Text="Thông tin người bị kiện"></asp:Literal></h4>

                                                        <div class="boder">
                                                            <table class="table1">
                                                                <asp:Panel ID="pnKoCoNYC" runat="server">
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="3">
                                                                            <asp:CheckBox ID="chkKhongCoNYC2" Text="Không có người yêu cầu 2" Font-Bold="true" Visible="false" runat="server" AutoPostBack="True" OnCheckedChanged="chkKhongCoNYC2_CheckedChanged" />
                                                                        </td>
                                                                    </tr>
                                                                </asp:Panel>
                                                                <tr>
                                                                    <td style="width: 115px;">Người bị kiện là<span class="batbuoc">*</span></td>
                                                                    <td style="width: 195px;">
                                                                        <asp:DropDownList ID="ddlLoaiBidon" CssClass="chosen-select"
                                                                            runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiBidon_SelectedIndexChanged">
                                                                            <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                                            <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                                            <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    <td style="width: 90px;">
                                                                        <asp:Label ID="lblBD_HoTen" runat="server" Text="Họ tên"></asp:Label><span class="batbuoc">*</span></td>

                                                                    <td>
                                                                        <asp:TextBox ID="txtBD_Ten" CssClass="textbox"
                                                                            runat="server" Width="295px"></asp:TextBox></td>
                                                                </tr>
                                                                <asp:Panel ID="pnBD_Tochuc" runat="server" Visible="false">
                                                                    <tr>
                                                                        <td>Địa chỉ</td>
                                                                        <td>
                                                                            <asp:DropDownList ID="dropToChuc_BD_Tinh" runat="server"
                                                                                AutoPostBack="true" OnSelectedIndexChanged="dropToChuc_BD_SelectedIndexChanged"
                                                                                CssClass="chosen-select" placeholder="---Tỉnh/TP---" Width="180px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td>Quận/Huyện</td>
                                                                        <td>
                                                                            <asp:DropDownList ID="dropTochuc_BD_QuanHuyen" runat="server" Width="309px"
                                                                                CssClass="chosen-select" placeholder="---Quận/Huyện---">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Địa chỉ chi tiết</td>
                                                                        <td colspan="3">
                                                                            <asp:TextBox ID="txtToChuc_BD_DiaChiCT" CssClass="textbox"
                                                                                placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                                                runat="server" Width="582px" MaxLength="250"></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="3"><i class='warning_dc'>(Địa chỉ này dùng để nhận các văn bản, thông báo từ Tòa án)</i></td>
                                                                    </tr>
                                                                    <!---------------------------------------->
                                                                    <tr>
                                                                        <td>Người đại diện</td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtBD_NDD_ten" CssClass="textbox" runat="server" Width="165px"></asp:TextBox></td>
                                                                        <td>Chức vụ</td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtBD_NDD_Chucvu" CssClass="textbox" runat="server" Width="295px"></asp:TextBox></td>
                                                                    </tr>
                                                                </asp:Panel>

                                                                <tr>
                                                                    <td>Số CMND/ Thẻ căn cước/ Hộ chiếu</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtBD_CMND" CssClass="textbox"
                                                                            runat="server" Width="165px"></asp:TextBox></td>
                                                                    <td>Giới tính</td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlBD_Gioitinh" CssClass="chosen-select"
                                                                            runat="server" Width="309px">
                                                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                                            <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                                                        </asp:DropDownList></td>
                                                                </tr>
                                                                <asp:Panel ID="pnBD_Canhan" runat="server">
                                                                    <tr>
                                                                        <td>Quốc tịch<span class="batbuoc">*</span></td>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBD_Quoctich"
                                                                                CssClass="chosen-select" runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlBD_Quoctich_SelectedIndexChanged">
                                                                            </asp:DropDownList></td>
                                                                        <td>Ngày sinh</td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtBD_Ngaysinh" runat="server" CssClass="textbox" Width="70px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtBD_Ngaysinh_TextChanged"></asp:TextBox>
                                                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtBD_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtBD_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                                                            <div style="float: right; line-height: 30px; margin-right: 20px;">
                                                                                <span style="margin-right: 20px;">Năm sinh</span>
                                                                                <asp:TextBox ID="txtBD_Namsinh" CssClass="textbox margin_cell_right2"
                                                                                    AutoPostBack="true" OnTextChanged="txtBD_Namsinh_TextChanged"
                                                                                    runat="server" onkeypress="return isNumber(event)" Width="90px" MaxLength="4"></asp:TextBox>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td colspan="3">
                                                                            <asp:CheckBox ID="chkBD_ONuocNgoai" AutoPostBack="true" OnCheckedChanged="chkBD_CheckedChanged"
                                                                                runat="server" Text=" Quốc tịch Việt Nam nhưng sinh sống ở nước ngoài" />
                                                                        </td>
                                                                    </tr>
                                                                    <!---------------------------------------->
                                                                    <asp:Panel ID="pnBiDon_HK" runat="server">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Literal ID="ltlNoiCuTru" runat="server" Text="Nơi cư trú"></asp:Literal>

                                                                            <td>
                                                                                <asp:DropDownList ID="dropBD_Tinh_TamTru" runat="server"
                                                                                    AutoPostBack="true" OnSelectedIndexChanged="dropBD_Tinh_TamTru_SelectedIndexChanged"
                                                                                    CssClass="chosen-select" placeholder="Tỉnh" Width="180px">
                                                                                </asp:DropDownList>
                                                                            <td>
                                                                                <asp:Label ID="lblBiDon_HuyenLabel" runat="server" Text="Quận/Huyện"></asp:Label>
                                                                                <%--<asp:Literal ID="lblBiDon_Huyen" runat="server"></asp:Literal>--%>
                                                                            </td>
                                                                            <td>
                                                                                <asp:DropDownList ID="dropBD_QuanHuyen_TamTru" runat="server"
                                                                                    CssClass="chosen-select" placeholder="Tỉnh" Width="309px">
                                                                                </asp:DropDownList>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Địa chỉ chi tiết <span class='batbuoc' id="label_bd_tamtru_chitiet">*</span></td>
                                                                            <td colspan="3">
                                                                                <asp:TextBox ID="txtBD_Tamtru_Chitiet" CssClass="textbox" placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                                                    runat="server" Width="582px"></asp:TextBox></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td colspan="3"><i class='warning_dc'>(Địa chỉ này dùng để nhận các văn bản, thông báo từ Tòa án)</i></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Nơi làm việc</td>
                                                                            <td colspan="3">
                                                                                <asp:TextBox ID="txtBD_DiaChiCoQuan" CssClass="textbox"
                                                                                    runat="server" Width="582px"></asp:TextBox></td>
                                                                        </tr>
                                                                    </asp:Panel>
                                                                    <!---------------------------------------->

                                                                </asp:Panel>
                                                                <tr>
                                                                    <td>Email</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtBD_Email" CssClass="textbox" runat="server" Width="165px"></asp:TextBox></td>
                                                                    <td>Điện thoại</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtBD_Dienthoai" runat="server" onkeypress="return isNumber(event)"
                                                                            CssClass="textbox" Width="90px"></asp:TextBox>
                                                                        <div style="float: right; line-height: 30px; margin-right: 20px;">

                                                                            <span style="float: left; margin-right: 10px">Fax</span>
                                                                            <asp:TextBox ID="txtBD_Fax" runat="server" onkeypress="return isNumber(event)"
                                                                                CssClass="textbox align_right margin_cell_right2" Width="90px"></asp:TextBox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                    <td colspan="2">

                                                                        <a href="javascript:" class="link_them_duongsu float_right align_right them_user"
                                                                            id="lkBiDon" style="margin-right: 30px;"
                                                                            onclick="show_popup_by_loaids('<%=BIDON %>')">Thêm người bị kiện khác</a></td>
                                                                </tr>
                                                            </table>
                                                            
                                                            <div style="float: left; width: 100%;">
                                                                <div style="display: none">
                                                                    <asp:Button ID="cmdLoadDsBiDonKhac" runat="server"
                                                                        Text="Load ds nguyen don khac" OnClick="cmdLoadDsBiDonKhac_Click" />
                                                                </div>
                                                                <asp:Literal ID="lttDsBiDonKhacTitle" runat="server" Visible="false"></asp:Literal>

                                                                <div style="float: right;" class="msg_thongbao">
                                                                    <asp:Literal ID="lttMsgBiDon" runat="server"></asp:Literal>
                                                                </div>

                                                                <asp:Repeater ID="rptBiDonKhac" runat="server"
                                                                    OnItemCommand="rptBiDonKhac_ItemCommand">
                                                                    <HeaderTemplate>
                                                                        <div class="CSSTableGenerator">
                                                                            <table>

                                                                                <tr id="row_header">
                                                                                    <td style="width: 20px;">TT</td>
                                                                                    <td>Họ và tên</td>
                                                                                    <td>Nơi cư trú hiện tại</td>
                                                                                    <td style="width: 70px;">Thao tác</td>
                                                                                </tr>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <tr>
                                                                            <td><%# Container.ItemIndex + 1 %>
                                                                                <asp:HiddenField ID="hddDuongSuID" runat="server"
                                                                                    Value=' <%#Eval("ID") %>' />
                                                                            </td>
                                                                            <td>
                                                                                <div style="text-align: justify; float: left;">
                                                                                    <%#Eval("TENDUONGSU") %>
                                                                                </div>
                                                                            </td>

                                                                            <td><%#Eval("TamTruChiTiet") %></td>

                                                                            <td>
                                                                                <div style="text-align: center;">
                                                                                    <asp:ImageButton ID="imgXoa" CssClass="xsize" runat="server" ImageUrl="/UI/img/delete.png"
                                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:ImageButton>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </ItemTemplate>
                                                                    <FooterTemplate></table></div></FooterTemplate>
                                                                </asp:Repeater>

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!------------------------------------>
                                                    <asp:Panel ID="pnDuongSu" runat="server">
                                                        <div class="boxchung">
                                                            <h4 class="tleboxchung">Người có quyền, lợi ích được bảo vệ/Người có quyền lợi, nghĩa vụ liên quan/Người làm chứng</h4>
                                                            <div class="boder">
                                                                <div style="float: left; width: 100%;" class="msg_thongbao">
                                                                    <asp:Literal ID="lttMsgDS" runat="server"></asp:Literal>
                                                                </div>
                                                                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                                                <div class="phantrang">
                                                                    <div class="sobanghi" style="float: right; margin-bottom: 5px; text-align: right;">
                                                                        <asp:Literal ID="lttLink" runat="server"></asp:Literal>
                                                                        <asp:Literal ID="lstSobanghiT" runat="server" Visible="false"></asp:Literal>
                                                                    </div>
                                                                    <asp:Panel runat="server" ID="pnPagingDSKhacTop" Visible="false">
                                                                        <div class="sotrang" style="float: left; text-align: left;">
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
                                                                    </asp:Panel>
                                                                </div>

                                                                <asp:Repeater ID="rptDuongSuKhac" runat="server"
                                                                    OnItemCommand="rptDuongSuKhac_ItemCommand" OnItemDataBound="rptDuongSuKhac_ItemDataBound">
                                                                    <HeaderTemplate>
                                                                        <div class="CSSTableGenerator">
                                                                            <table>

                                                                                <tr id="row_header">
                                                                                    <td style="width: 20px;">TT</td>
                                                                                    <td>Đương sự</td>
                                                                                    <%-- <td>Địa chỉ (Thường trú/Trụ sở chính)</td>--%>
                                                                                    <td>Đương sự là</td>
                                                                                    <td>Tư cách tố tụng</td>
                                                                                    <td>Đại diện</td>
                                                                                    <td style="width: 70px;">Thao tác</td>
                                                                                </tr>
                                                                    </HeaderTemplate>
                                                                    <ItemTemplate>
                                                                        <tr>
                                                                            <td><%# Container.ItemIndex + 1 %>
                                                                                <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                                                                    Value=' <%#Eval("ID") %>' />
                                                                            </td>
                                                                            <td>
                                                                                <div style="text-align: justify; float: left;">
                                                                                    <%#Eval("TENDUONGSU") %>
                                                                                </div>
                                                                            </td>

                                                                            <td><%#Eval("TENLOAIDS") %></td>
                                                                            <td><%#Eval("TuCachToTung") %></td>
                                                                            <td>
                                                                                <div style="text-align: center;"><%#Eval("DAIDIEN") %></div>
                                                                            </td>
                                                                            <td>
                                                                                <div style="text-align: center;">
                                                                                    <asp:ImageButton ID="imgXoa" runat="server" ImageUrl="/UI/img/delete.png"
                                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:ImageButton>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </ItemTemplate>
                                                                    <FooterTemplate></table></div></FooterTemplate>
                                                                </asp:Repeater>
                                                                <asp:Panel runat="server" ID="PpnPagingDSKhacBottom" Visible="false">
                                                                    <div class="phantrang">
                                                                        <div class="sobanghi" style="float: right; text-align: right;">
                                                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                                        </div>
                                                                        <div class="sotrang" style="float: left; text-align: left;">
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
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                    <!------------------------------------>
                                                    <div class="boxchung">
                                                        <div class="boder" style="margin-top: 0px;">
                                                            <table class="table1" style="width: 99%;">

                                                                <tr runat="server" id="trLydoLyhon" visible="false">
                                                                    <td>Số con chưa thành niên</td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtSoconchuathanhnien" CssClass="textbox" onkeypress="return isNumber(event)" runat="server" Width="110px" MaxLength="2"></asp:TextBox>
                                                                    </td>
                                                                    <td>Lý do xin ly hôn<span class="batbuoc">*</span></td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlLydoLyhon" CssClass="chosen-select" runat="server" Width="295px"></asp:DropDownList></td>
                                                                </tr>

                                                                <asp:Panel ID="pnHanhChinh" runat="server" Visible="false">
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <div style="float: left; width: 100%; margin-bottom: 8px;">
                                                                                <span style="width: 65px;">Quyết định bị kiện</span>
                                                                                <asp:DropDownList ID="dropLoaiQDHanhChinh" Width="250px"
                                                                                    CssClass="chosen-select" runat="server">
                                                                                </asp:DropDownList>
                                                                                <span style="width: 65px; margin-left: 10px;">số </span>
                                                                                <span id="span_soqd"></span>
                                                                                <asp:TextBox ID="txtSoQD" runat="server"
                                                                                    CssClass="textbox border_bottom_textbox" Width="128px"></asp:TextBox>
                                                                                <span style="margin-left: 10px;">ngày</span><span
                                                                                    style="margin-right: 5px;" id="span_ngayqd"></span>
                                                                                <asp:TextBox ID="txtNgayQD" runat="server"
                                                                                    CssClass="textbox border_bottom_textbox" Width="100px" MaxLength="10"></asp:TextBox>
                                                                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                            </div>
                                                                            <div style="float: left; width: 100%; margin-bottom: 8px;">
                                                                                <span style="float: left; line-height: 23px; margin-right: 5px;">của </span>
                                                                                <asp:TextBox ID="txtQDHC_Cua" CssClass="textbox float_left border_bottom_textbox"
                                                                                    runat="server" Width="270px"></asp:TextBox>
                                                                                <span style="float: left; line-height: 23px; margin-right: 5px; margin-left: 5px;">về</span>
                                                                                <asp:TextBox ID="txtQDHanhChinh" CssClass="textbox border_bottom_textbox"
                                                                                    runat="server" Width="385px"></asp:TextBox>
                                                                            </div>
                                                                            <div style="float: left; width: 100%;">
                                                                                <span style="margin: 5px 0px 10px 0px; float: left;">Hành vi hành chính bị kiện: </span>
                                                                                <asp:TextBox ID="txtHanhViHC" CssClass="textbox border_bottom_textbox"
                                                                                    runat="server" Width="540px"></asp:TextBox>
                                                                            </div>
                                                                            <div style="float: left; width: 100%;">
                                                                                <span style="float: left; margin-top: 5px; line-height: 22px;">Tóm tắt nội dung quyết định:</span><asp:TextBox ID="txtTomTatHanhViHCBiKien"
                                                                                    CssClass="textbox border_bottom_textbox"
                                                                                    placeholder="(Ghi tóm tắt nội dung cụ thể của quyết định hành chính)"
                                                                                    runat="server" Width="98.5%" TextMode="MultiLine" Rows="1"></asp:TextBox>
                                                                            </div>
                                                                            <div style="float: left; width: 100%;">
                                                                                <span style="margin-top: 5px; float: left;">Nội dung quyết định giải quyết khiếu nại (nếu có):</span>
                                                                                <asp:TextBox ID="txtNoiDungQDHC" CssClass="textbox border_bottom_textbox"
                                                                                    Rows="1" TextMode="MultiLine"
                                                                                    runat="server" Width="98.5%"></asp:TextBox>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </asp:Panel>
                                                                <tr>
                                                                    <td colspan="4">Yêu cầu tòa án giải quyết những vấn đề: <span class="batbuoc">*</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4">
                                                                        <asp:TextBox ID="txtNoidungdon" runat="server"
                                                                            placeholder="(Nêu cụ thể từng vấn đề yêu cầu Tòa án giải quyết)"
                                                                            Width="96.5%" Rows="2" CssClass="textbox" TextMode="MultiLine"></asp:TextBox>
                                                                    </td>
                                                                </tr>

                                                                <asp:Panel ID="pnHanhChinh2" runat="server" Visible="false">
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <div style="float: left; width: 100%; line-height: 22px; margin: 5px 0px;">
                                                                                Người khởi kiện cam đoan không đồng thời khiếu nại
                                                      
                                                        <span id='zone_loaiqdhc'>....</span> đến người có thẩm quyền giải quyết khiếu nại
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </asp:Panel>
                                                                <tr>
                                                                    <td style="width: 115px;">Quan hệ pháp luật</td>
                                                                    <td colspan="3">
                                                                        <asp:DropDownList ID="dropQHPL" CssClass="chosen-select"
                                                                            runat="server" Width="610px">
                                                                        </asp:DropDownList></td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>
                                                    <!------------------------------------>
                                                    <div class="fullwidth" style="margin-top: 0px;">
                                                        <div class="boxchung">
                                                            <h4 class="tleboxchung">Tài liệu, chứng cứ kèm theo đơn khởi kiện</h4>
                                                            <div class="boder">
                                                                <!-----------------tai lieu khac----------------------------->
                                                                <asp:Panel ID="pnAddFile" runat="server">
                                                                    <table style="float: left; width: 100%;">
                                                                        <tr>
                                                                            <td colspan="2"><b>Ghi chú:</b>
                                                                                <i>
                                                                                    <asp:Literal ID="lttGhiChuTitle" runat="server"></asp:Literal>
                                                                                    <ul class="ds_tailieu_denghi">
                                                                                        <asp:Repeater ID="rptGhiChu" runat="server">
                                                                                            <ItemTemplate>
                                                                                                <li><%#Eval("TenTaiLieu") %></li>
                                                                                            </ItemTemplate>
                                                                                        </asp:Repeater>
                                                                                        <li>Để thêm tài liệu: bạn nhập "Tên tài liệu", bấm chọn "Chọn file đính kèm và ký số" để thêm tài liệu
                                                                                        </li>
                                                                                        <li>Tài liệu đính kèm có định dạng .pdf và không quá 2MB</li>
                                                                                        <li>Các tài liệu không thể gửi trực tuyến qua hệ thống cần nộp trực tiếp tại Tòa án</li>
                                                                                    </ul>
                                                                                </i>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="2"><b>Tài liệu</b></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 85px;">Tên tài liệu</td>
                                                                            <td>
                                                                                <asp:TextBox ID="txtTenTaiLieu" runat="server"
                                                                                    CssClass="textbox" Width="298px"></asp:TextBox></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Tệp đính kèm</td>
                                                                            <td>
                                                                                <div style="display: none;">
                                                                                    <!------------------>
                                                                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                                                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                                                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                                                                    <div style="float: left; margin-right: 10px;">
                                                                                        <button type="button" class="buttonkyso" id="FileUpload1"
                                                                                            onclick="exc_sign_file1();">
                                                                                            Chọn file đính kèm</button>
                                                                                        <span style="display: none">
                                                                                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình</button><br />
                                                                                        </span>
                                                                                    </div>
                                                                                </div>
                                                                                <!--------anhvh edit---------->
                                                                                <div style="display: none;">
                                                                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                                                                    <cc1:AsyncFileUpload ID="Tailieu_Upload" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Traditional" OnUploadedComplete="Tailieu_Upload_Complete"
                                                                                        OnClientUploadComplete="UploadGrid" ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                                                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                                                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                                                                </div>
                                                                                <asp:Label ID="lblMesg" runat="server" Text=""></asp:Label>
                                                                                <div style="display: none;">
                                                                                    <asp:HiddenField ID="Hi_fileEx" runat="server" Value="" />
                                                                                    <asp:Button ID="Save_File" runat="server" CssClass="buttoninput"
                                                                                        Text="Lưu File" OnClick="Save_File_Click" CausesValidation="false" />
                                                                                </div>
                                                                                <script>
                                                                                    function UploadGrid(sender) {
                                                                                        $("#<%= Save_File.ClientID %>").click();
                                                                                    <%--   $get("<%=lblMesg.ClientID%>").innerHTML = "File Uploaded Successfully";--%>
                                                                                    }
                                                                                </script>
                                                                                <!--------anhvh edit end---------->
                                                                                <div style="width: 400px; float: left;">
                                                                                    <asp:Button runat="server" ID="Button1" CssClass="btnUpload" Text="Chọn tài liệu" OnClientClick="openfileDialog();return false" />
                                                                                    <asp:FileUpload ID="fu_FILE_ATTACT" runat="server" CssClass="file_attact_ss" Style="visibility: hidden;" />
                                                                                </div>
                                                                                <div style="width: 100px; float: left">
                                                                                    <asp:Button ID="btn_saveFileAttach" runat="server" CssClass="buttoninput luufile"
                                                                                        OnClientClick="javascript:return Upload_Check();" TabIndex="1" Text="Lưu file"
                                                                                        CausesValidation="true"
                                                                                        OnClick="cmdSaveFileAttach_Click" />
                                                                                </div>
                                                                                <script src="/UI/js/1.7.2/jquery.min.js" type="text/javascript"></script>
                                                                                <script>
                                                                                    function openfileDialog() {
                                                                                            var v_file = document.getElementById('<%= fu_FILE_ATTACT.ClientID %>');
                                                                                            v_file.click();
                                                                                        }
                                                                                    function Upload_Check() {
                                                                                        var v_file = document.getElementById('<%= fu_FILE_ATTACT.ClientID %>');
                                                                                        var myfile = v_file.value.toUpperCase();
                                                                                        if (myfile == '') {
                                                                                            window.confirm('File Attach chưa được chọn');
                                                                                            return false;
                                                                                        }
                                                                                        if (myfile.indexOf("PDF") <= 0) {
                                                                                            window.confirm('File lựa chọn phải có định dạng là file .pdf');
                                                                                            return false;
                                                                                        }
                                                                                        var maxFileSize = (2 * 1024 * 1024); // 2MB
                                                                                        var CurrentSize = 0;
                                                                                        var fileUpload = $("[id$='fu_FILE_ATTACT']");
                                                                                        CurrentSize = fileUpload[0].files[0].size
                                                                                        if (CurrentSize > maxFileSize) {
                                                                                            alert('File lựa chọn phải nhỏ hơn hoặc bằng 2M');
                                                                                            return false;
                                                                                        }
                                                                                        return true;
                                                                                    }
                                                                                    //------------------
                                                                                </script>
                                                                                <!------------------>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="4">
                                                                                <div class="msg_thongbao">
                                                                                    <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </table>

                                                                </asp:Panel>

                                                                <div class="CSSTableGenerator">
                                                                    <table>
                                                                        <tr id="row_header">
                                                                            <td style="width: 20px;">TT</td>
                                                                            <td>Tên tài liệu</td>
                                                                            <td style="width: 70px;">Xem file</td>
                                                                            <asp:Literal ID="lttThaoTacFile" runat="server"></asp:Literal>

                                                                        </tr>
                                                                        <%--OnItemDataBound="rptFile_ItemDataBound"--%>
                                                                        <asp:Repeater ID="rptFile" runat="server" OnItemCommand="rptFile_ItemCommand">
                                                                            <ItemTemplate>
                                                                                <tr>
                                                                                    <td><%# Container.ItemIndex + 1 %>
                                                                                        <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                                                                            Value=' <%#Eval("ID") %>' />
                                                                                    </td>
                                                                                    <td>
                                                                                        <div style="text-align: justify; float: left;">
                                                                                            <%#Eval("TenTaiLieu") %>
                                                                                        </div>
                                                                                    </td>

                                                                                    <td>
                                                                                        <div style="text-align: center;">
                                                                                            <asp:ImageButton ID="cmdDowload" ImageUrl="/UI/img/dowload.png"
                                                                                                runat="server" ToolTip="Tải file" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                                                                                                CommandName="dowload"></asp:ImageButton>
                                                                                        </div>
                                                                                    </td>
                                                                                    <asp:Panel ID="pnXoaFile" runat="server">
                                                                                        <td>
                                                                                            <div style="text-align: center;">
                                                                                                <asp:ImageButton ID="cmdXoa" runat="server" ImageUrl="/UI/img/delete.png"
                                                                                                    CommandArgument='<%#Eval("ID").ToString() %>' CommandName="Delete" ToolTip="Xóa"
                                                                                                    OnClientClick="return confirm('Bạn có thực sự muốn xóa mục này?');" Width="20px"></asp:ImageButton>
                                                                                            </div>
                                                                                        </td>
                                                                                    </asp:Panel>
                                                                                </tr>
                                                                            </ItemTemplate>

                                                                        </asp:Repeater>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <asp:Panel ID="pnDanSu" runat="server">
                                                        <div class="fullwidth">
                                                            <table class="table1" style="width: 100%;">
                                                                <tr>
                                                                    <td colspan="4">Các thông tin khác mà người khởi kiện xét thấy cần thiết cho việc giải quyết vụ án (nếu có)</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4">
                                                                        <asp:TextBox ID="txtThongTinDansu_Them" runat="server"
                                                                            Width="99%" Rows="1"
                                                                            CssClass="textbox" TextMode="MultiLine"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </asp:Panel>

                                                    <!------------------------------------>
                                                    <div class="fullwidth" style="text-align: center;">
                                                        <asp:Literal runat="server" ID="lbthongbao"></asp:Literal>

                                                        <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput bg_do"
                                                            Text="Lưu & In đơn" OnClick="cmdPrint_Click"
                                                            OnClientClick="return validate();" />

                                                        <asp:Button ID="cmdLuu" runat="server" CssClass="buttoninput bg_do"
                                                            Text="Lưu đơn" OnClick="cmdLuu_Click"
                                                            OnClientClick="return validate();" />

                                                        <asp:HiddenField ClientIDMode="Static" ID="Signature1" runat="server" />
                                                        <asp:Button ID="cmdGuiDon" runat="server" CssClass="buttoninput bg_do"
                                                            Text="Gửi đơn" OnClick="cmdGuiDon_Click"
                                                            OnClientClick="return validate_guidon(); " />

                                                    </div>
                                                    <div class="fullwidth" style="text-align: center;">
                                                        <div class="msg_thongbao">
                                                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                                                        </div>
                                                    </div>
                                                    <!------------------------------------>
                                                    <div class="helpcontent" style="margin-bottom: 10px; margin-top: 5px; box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                                                        <b class="helpcontent_title"><a href="javascript:;">Lưu ý:</a></b>
                                                        <p style="margin-top: 5px;">
                                                            Để gửi đơn khởi kiện, bạn cần sử dụng thiết bị chứng thư số 
                                    được dùng khi đăng ký tạo tài khoản trong hệ thống này!
                                                        </p>
                                                    </div>
                                                    <div style="display: none">
                                                        <asp:Button ID="cmdThemFileTL" runat="server"
                                                            Text="Them tai lieu" OnClick="cmdThemFileTL_Click" />
                                                        <asp:Button ID="cmdLoadDsDuongSu" runat="server"
                                                            Text="Ds đương sự" OnClick="cmdLoadDsDuongSu_Click" />
                                                    </div>
                                                </div>
                                            </div>
                                            <!--------------------------------------------->
                                        </div>
                                    </div>
                                </div>

                                <!-----------------KT chứng thu so---------------------------->
                                <script>
                                    function loadNguoiUyQuyen() {
                                        $("#ContentPlaceHolder1_Thongtinnguoiuyquyen_cmdTimkiem").click();
                                    }
                                    var _signed = false;
                                    function AuthCallBack(sender, rv) {
                                        console.log(rv);
                                        //alert(sender);
                                        var json_rv = JSON.parse(rv);
                                        if (json_rv.Status == 0) {
                                            document.getElementById("Signature1").value = json_rv.Signature;
                                            _signed = true;
                                            //document.getElementById(sender).click();
                                            sender.click();
                                        } else {
                                            _signed = false;
                                            // alert("Ký số không thành công:" + json_rv.Status + ":" + json_rv.Error);
                                            alert("Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt." + json_rv.Error);
                                        }
                                    }

                                    function exc_auth(sender) {
                                        if (_signed)
                                            return true;
                                        var s1 = "<%=Session["AuthCode"]%>";
                                        console.log(s1);
                                        vgca_auth(sender, s1, AuthCallBack);
                                        return false;
                                    }

                                </script>
                                <!--------------------------------------------->
                                <script>
                                    function pageLoad(sender, args) {
                                        $(function () {
                                            var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetAllToaNhanDKKOnline") %>';
                                            $("[id$=txtToaAn]").autocomplete({
                                                source: function (request, response) {
                                                    $.ajax({
                                                        url: urldm_toaan,
                                                        data: "{ 'textsearch': '" + request.term + "'}",
                                                        dataType: "json", type: "POST",
                                                        contentType: "application/json; charset=utf-8",

                                                        success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) },
                                                        error: function (response) { }, failure: function (response) { }
                                                    });
                                                },
                                                select: function (e, i) { $("[id$=hddToaAnID]").val(i.item.val); }, minLength: 1
                                            });
                                        });

                                        //--------------------------------------------
                                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                                        for (var selector in config) { $(selector).chosen(config[selector]); }
                                    }

                                </script>

                                <script>         
                                    function validate() {
                                        var soluongkytu = 250;
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);

                                        if (!validate_toaan())
                                            return false;
                                        //------------------------------
                                        if (!Validate_NguyenDon())
                                            return false;

                                        if (!Validate_BiDon())
                                            return false;

                                        var hddLinhVucVuViec = document.getElementById('<%=hddLinhVucVuViec.ClientID%>');
                                        if (hddLinhVucVuViec.value == "AN_HANHCHINH") {
                                            if (!validate_QDHanhChinh())
                                                return false;
                                        }

                                        //------------------------------------
                                        var txtNoidungdon = document.getElementById('<%=txtNoidungdon.ClientID%>');
                                        if (!Common_CheckEmpty(txtNoidungdon.value)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Bạn chưa nhập mục 'Yêu cầu tòa án giải quyết những vấn đề'. Hãy kiểm tra lại!";
                                            txtNoidungdon.focus();
                                            return false;
                                        }

                                        soluongkytu = 2000;
                                        if (!Common_CheckLengthString(txtNoidungdon, soluongkytu)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Mục 'Yêu cầu tòa án giải quyết những vấn đề' không thể nhập quá " + soluong + " ký tự. Hãy kiểm tra lại!";
                                            txtNoidungdon.focus();
                                            return false;
                                        }
                                        //-----------------------------------
                                        if (hddLinhVucVuViec.value == "AN_DANSU") {
                                            var txtThongTinDansu_Them = document.getElementById('<%=txtThongTinDansu_Them.ClientID%>');
                                            if (Common_CheckEmpty(txtThongTinDansu_Them.value)) {
                                                soluongkytu = 2000;
                                                if (!Common_CheckLengthString(txtThongTinDansu_Them, soluongkytu)) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = "Mục 'Các thông tin khác mà người khởi kiện xét thấy cần thiết cho việc giải quyết vụ án' không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                    txtThongTinDansu_Them.focus();
                                                    return false;
                                                }
                                            }
                                        }

                                        zone_message.style.display = "none";
                                        //-----------------------
                                        return true;
                                    }
                                    function validate_guidon() {
                                        if (!validate())
                                            return false;
                                            //-------------chuc nang check ky so -------------
                                            <%--var cmdGuiDon = document.getElementById('<%=cmdGuiDon.ClientID%>');
                                            if (!exc_auth(cmdGuiDon))
                                                return false;--%>
                                        var ret_confirm = confirm('Bạn có chắc chắn gửi đơn khởi kiện này đến Tòa án không?');
                                        return ret_confirm;
                                    }
                                    function validate_QDHanhChinh() {
                                        var soluongkytu = 250;
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);

                                        var dropLoaiQDHanhChinh = document.getElementById('<%= dropLoaiQDHanhChinh.ClientID%>');
                                        var txtHanhViHC = document.getElementById('<%=txtHanhViHC.ClientID%>');

                                        var value_change = dropLoaiQDHanhChinh.options[dropLoaiQDHanhChinh.selectedIndex].value;
                                        var checkempty_hanhvihc = Common_CheckEmpty(txtHanhViHC.value);
                                        if ((checkempty_hanhvihc == false) && (value_change == "0")) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Bạn cần chọn 'Quyết định bị kiện' "
                                                + "hoặc nhập 'Hành vi hành chính bị kiện'. ";
                                            + "Hãy kiểm tra lại!";
                                            txtHanhViHC.focus();
                                            return false;
                                        }

                                        //-------------------------------
                                        if (value_change != "0") {
                                            var txtSoQD = document.getElementById('<%=txtSoQD.ClientID%>');
                                            if (!Common_CheckTextBox2(txtSoQD, 'Số QĐ', zone_message_name))
                                                return false;
                                            else {
                                                soluongkytu = 250;
                                                if (!Common_CheckLengthString(txtSoQD, soluongkytu)) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = "Số QĐ không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                    txtSoQD.focus();
                                                    return false;
                                                }
                                            }
                                            //-------------------------------
                                            var txtNgayQD = document.getElementById('<%=txtNgayQD.ClientID%>');
                                            if (!Common_CheckEmpty(txtNgayQD.value)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Bạn chưa chọn ngày ra quyết định. Hãy kiểm tra lại!";
                                                txtNgayQD.focus();
                                                return false;
                                            }
                                            else {
                                                var now = new Date();
                                                var temp = txtNgayQD.value.split('/');
                                                temp = new Date(temp[2], temp[1] - 1, temp[0]);
                                                if (temp > now) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = 'Ngày ra quyết định phải nhỏ hơn hoặc bằng ngày hiện tại!';
                                                    txtNgayQD.focus();
                                                    return false;
                                                }
                                            }
                                        }
                                        //-------------------------------
                                        var txtQDHanhChinh = document.getElementById('<%=txtQDHanhChinh.ClientID%>');
                                        if (Common_CheckEmpty(txtQDHanhChinh.value)) {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtQDHanhChinh, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Quyết định hành chính không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtQDHanhChinh.focus();
                                                return false;
                                            }
                                        }
                                        //-------------------------------
                                        if (checkempty_hanhvihc == true) {
                                            soluongkytu = 500;
                                            if (!Common_CheckLengthString(txtHanhViHC, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Mục 'Hành vi hành chính bị kiện' không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtHanhViHC.focus();
                                                return false;
                                            }
                                        }
                                        //-------------------------------
                                        var txtTomTatHanhViHCBiKien = document.getElementById('<%=txtTomTatHanhViHCBiKien.ClientID%>');
                                        if (Common_CheckEmpty(txtTomTatHanhViHCBiKien.value)) {
                                            soluongkytu = 1000;
                                            if (!Common_CheckLengthString(txtTomTatHanhViHCBiKien, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Tóm tắt nội dung quyết định hành chính không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtTomTatHanhViHCBiKien.focus();
                                                return false;
                                            }
                                        }
                                        //-------------------------------
                                        var txtNoiDungQDHC = document.getElementById('<%=txtNoiDungQDHC.ClientID%>');
                                        if (Common_CheckEmpty(txtNoiDungQDHC.value)) {
                                            soluongkytu = 2000;
                                            if (!Common_CheckLengthString(txtNoiDungQDHC, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Nội dung quyết định giải quyết khiếu nại không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtNoiDungQDHC.focus();
                                                return false;
                                            }
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function validate_toaan() {

                                        <%--var zone_message = document.getElementById('zone_message');
                                        var hddToaAnID = document.getElementById('<%=hddToaAnID.ClientID%>');
                                        var txtToaAn = document.getElementById('<%=txtToaAn.ClientID%>');
                                        if (!Common_CheckEmpty(txtToaAn.value))
                                            hddToaAnID.value = "";
                                        var ToaAnId = hddToaAnID.value;
                                        if (!Common_CheckEmpty(ToaAnId)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!";
                                            txtToaAn.focus();
                                            return false;
                                        }--%>
                                        var ddlToaanID = document.getElementById('<%=ddlToaanID.ClientID%>');
                                        var value_change = ddlToaanID.options[ddlToaanID.selectedIndex].value;
                                        if (value_change == "0") {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Chưa nhập Tòa án để gửi đơn. Hãy kiểm tra lại!";
                                            ddlToaanID.focus();
                                            return false;
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }

                                    function Validate_NguyenDon() {
                                        var loaitk = GetValueRadioList("<%=rdUyQuyen.ClientID%>");
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;
                                        var temp = "";

                                        //-------------------------------                
                                        var ddlLoaiNguyendon = document.getElementById('<%=ddlLoaiNguyendon.ClientID%>');
                                        var loai_value = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].value;
                                        var loai_text = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].text + " khởi kiện";

                                        //-----------------------------
                                        if (loai_value == 1) {
                                            //check thong tin ca nhan 
                                            if (!Validate_NguyenDon_CaNhan())
                                                return false;
                                        }
                                        else {
                                            //check CQ/TC
                                            if (!Validate_NguyenDon_CoQuan())
                                                return false;
                                        }
                                        //----------------------------
                                        var txtND_Email = document.getElementById('<%=txtND_Email.ClientID%>');
                                        if (!Common_CheckEmpty(txtND_Email.value)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = 'Bạn chưa nhập địa chỉ email của người khởi kiện. Hãy kiểm tra lại!';
                                            txtND_Email.focus();
                                            return false;
                                        } else {
                                            var email = txtND_Email.value;
                                            if (!Common_ValidateEmail2(txtND_Email)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Định dạng email không hợp lệ.Hãy kiểm tra lại!";

                                                txtND_Email.focus();
                                                return false;
                                            }
                                            //-------------------------
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtND_Email, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Email không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtND_Email.focus();
                                                return false;
                                            }
                                        }

                                        //-------------------------------
                                        if (loai_value == 1) {
                                            var txtND_DiaChiCoQuan = document.getElementById('<%=txtND_DiaChiCoQuan.ClientID%>');
                                            if (Common_CheckEmpty(txtND_DiaChiCoQuan.value)) {
                                                soluongkytu = 500;
                                                if (!Common_CheckLengthString(txtND_DiaChiCoQuan, soluongkytu)) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = "Mục 'Nơi làm việc' không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                    txtND_DiaChiCoQuan.focus();
                                                    return false;
                                                }
                                            }
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function Validate_NguyenDon_CaNhan() {
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;

                                        //-----------------------------------
                                        var txtTennguyendon = document.getElementById('<%=txtTennguyendon.ClientID%>');
                                        if (!Common_CheckTextBox2(txtTennguyendon, "Tên người khởi kiện", zone_message_name))
                                            return false;
                                        else {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtTennguyendon, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Tên người khởi kiện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtTennguyendon.focus();
                                                return false;
                                            }
                                        }

                                        //-------------------------------    
                                        var txtND_CMND = document.getElementById('<%=txtND_CMND.ClientID%>');

                                        if (!Common_CheckTextBox2(txtND_CMND, "CMND/ Thẻ căn cước/ Hộ chiếu của người khởi kiện", zone_message_name))
                                            return false;
                                        else {
                                            soluongkytu = 50;
                                            if (!Common_CheckLengthString(txtND_CMND, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "CMND/ Thẻ căn cước/ Hộ chiếu của của người khởi kiện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtND_CMND.focus();
                                                return false;
                                            }
                                        }

                                        //-----------------------------
                                        if (!validate_quoctich_ND())
                                            return false;

                                        //--------------------------------------
                                        var CurrYear = '<%=CurrYear%>';
                                        var txtND_Ngaysinh = document.getElementById('<%=txtND_Ngaysinh.ClientID%>');
                                        if (Common_CheckEmpty(txtND_Ngaysinh.value)) {
                                            if (!CheckDateTimeControl2(txtND_Ngaysinh, 'Ngày sinh', zone_message_name))
                                                return false;

                                            var now = new Date();
                                            var temp = txtND_Ngaysinh.value.split('/');
                                            temp = new Date(temp[2], temp[1] - 1, temp[0]);
                                            if (temp > now) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = 'Ngày sinh của người khởi kiện phải nhỏ hơn hoặc bằng ngày hiện tại!';
                                                txtND_Ngaysinh.focus();
                                                return false;
                                            }
                                        }

                                        //----------------------------------------
                                        var txtND_Namsinh = document.getElementById('<%=txtND_Namsinh.ClientID%>');
                                        if (!Common_CheckEmpty(txtND_Namsinh.value)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = 'Bạn chưa nhập năm sinh của người khởi kiện. Hãy kiểm tra lại!';
                                            txtND_Namsinh.focus();
                                            return false;
                                        }

                                        var nam_sinh = parseInt(txtND_Namsinh.value);
                                        if (nam_sinh > CurrYear) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = 'Năm sinh của người khởi kiện không được phép lớn hơn năm: ' + CurrYear;
                                            txtND_Namsinh.focus();
                                            return false;
                                        }

                                        var sonam = CurrYear - nam_sinh;
                                        var status_uyquyen = GetValueRadioList("<%=rdUyQuyen.ClientID%>");
                                        if (sonam < 14) {
                                            zone_message.style.display = "block";
                                            /*if (loaitk == 1) {*/
                                            if (status_uyquyen == "2")
                                                zone_message.innerText = 'Người đại diện chưa đủ 14 tuổi. Hãy kiểm tra lại!';
                                            else
                                                zone_message.innerText = 'Cá nhân đăng ký tài khoản chưa đủ 14 tuổi. Hãy kiểm tra lại';

                                            txtND_Namsinh.focus();
                                            return false;
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function Validate_NguyenDon_CoQuan() {
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;

                                        //-------------------------------                
                                        var ddlLoaiNguyendon = document.getElementById('<%=ddlLoaiNguyendon.ClientID%>');
                                        var loai_cq_value = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].value;
                                        var loai_cq_text = "";
                                        if (loai_cq_value == 2)
                                            loai_cq_text = "cơ quan khởi kiện";
                                        else if (loai_cq_value == 3)
                                            loai_cqt_text = "tổ chức khởi kiện";
                                        //-------------------------------  
                                        var txtTennguyendon = document.getElementById('<%=txtTennguyendon.ClientID%>');
                                        if (!Common_CheckTextBox2(txtTennguyendon, "Tên " + loai_cq_text, zone_message_name))
                                            return false;
                                        else {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtTennguyendon, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Tên " + loai_cq_text + " không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtTennguyendon.focus();
                                                return false;
                                            }
                                        }
                                        //----------------------------------

                                        //----------------------------------
                                        var dropToChuc_Tinh = document.getElementById('<%=dropToChuc_Tinh.ClientID%>');
                                        var value_change = dropToChuc_Tinh.options[dropToChuc_Tinh.selectedIndex].value;
                                        if (value_change == "0") {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Tỉnh/TP của " + loai_cq_text + " chưa được chọn. Hãy kiểm tra lại!";
                                            dropToChuc_Tinh.focus();
                                            return false;
                                        }
                                        //------------------
                                        var dropToChuc_QuanHuyen = document.getElementById('<%=dropToChuc_QuanHuyen.ClientID%>');
                                        value_change = dropToChuc_QuanHuyen.options[dropToChuc_QuanHuyen.selectedIndex].value;
                                        if (value_change == "0") {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Quận/Huyện của " + loai_cq_text + " chưa được chọn. Hãy kiểm tra lại!";
                                            dropToChuc_Tinh.focus();
                                            return false;
                                        }
                                        //------------------
                                        var txtToChuc_DiaChiCT = document.getElementById('<%=txtToChuc_DiaChiCT.ClientID%>');
                                        if (!Common_CheckTextBox2(txtToChuc_DiaChiCT, "Địa chỉ chi tiết của " + loai_cq_text, zone_message_name))
                                            return false;
                                        soluongkytu = 50;
                                        if (!Common_CheckLengthString(txtToChuc_DiaChiCT, soluongkytu)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Địa chỉ chi tiết của " + loai_text + " không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                            txtToChuc_DiaChiCT.focus();
                                            return false;
                                        }
                                        //--------------------------------
                                        var txtToChuc_NguoiDD = document.getElementById('<%=txtToChuc_NguoiDD.ClientID%>');
                                        if (!Common_CheckTextBox2(txtToChuc_NguoiDD, "Tên người đại diện", zone_message_name))
                                            return false;

                                        soluongkytu = 250;
                                        if (!Common_CheckLengthString(txtToChuc_NguoiDD, soluongkytu)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Tên người đại diện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                            txtToChuc_NguoiDD.focus();
                                            return false;
                                        }
                                        //--------------
                                        var txtToChuc_NguoiDD_ChucVu = document.getElementById('<%=txtToChuc_NguoiDD_ChucVu.ClientID%>');
                                        if (Common_CheckEmpty(txtToChuc_NguoiDD_ChucVu.value)) {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtToChuc_NguoiDD_ChucVu, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Chức vụ của người đại diện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtToChuc_NguoiDD_ChucVu.focus();
                                                return false;
                                            }
                                        }
                                        //------------------------
                                        var txtND_CMND = document.getElementById('<%=txtND_CMND.ClientID%>');
                                        if (!Common_CheckTextBox2(txtND_CMND, "CMND/ Thẻ căn cước/ Hộ chiếu", zone_message_name))
                                            return false;
                                        else {
                                            soluongkytu = 50;
                                            if (!Common_CheckLengthString(txtND_CMND, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "CMND/ Thẻ căn cước/ Hộ chiếu không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtND_CMND.focus();
                                                return false;
                                            }
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                </script>
                                <script>
                                    function Validate_BiDon() {
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;

                                        //-------------------------------                
                                        var ddlLoaiBidon = document.getElementById('<%=ddlLoaiBidon.ClientID%>');
                                        var loai_value = ddlLoaiBidon.options[ddlLoaiBidon.selectedIndex].value;
                                        if (loai_value == 1) {
                                            if (!Validate_BiDon_CaNhan())
                                                return false;
                                        }
                                        else {
                                            if (!Validate_BiDon_CoQuan())
                                                return false;
                                        }
                                        //-----------------------------------
                                        var txtBD_Email = document.getElementById('<%=txtBD_Email.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_Email.value)) {
                                            var email = txtBD_Email.value;
                                            if (!Common_ValidateEmail2(txtBD_Email)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Định dạng email không hợp lệ.Hãy kiểm tra lại!";

                                                txtBD_Email.focus();
                                                return false;
                                            }
                                            //-------------------------
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtBD_Email, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Email không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtBD_Email.focus();
                                                return false;
                                            }
                                        }

                                        //-----------------------------------               
                                        if (loai_value == 1) {
                                            var txtBD_DiaChiCoQuan = document.getElementById('<%=txtBD_DiaChiCoQuan.ClientID%>');
                                            if (Common_CheckEmpty(txtBD_DiaChiCoQuan.value)) {
                                                soluongkytu = 500;
                                                if (!Common_CheckLengthString(txtBD_DiaChiCoQuan, soluongkytu)) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = "Mục 'Nơi làm việc' không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                    txtBD_DiaChiCoQuan.focus();
                                                    return false;
                                                }
                                            }
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function Validate_BiDon_CaNhan() {
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;

                                        var txtBD_Ten = document.getElementById('<%=txtBD_Ten.ClientID%>');
                                        if (!Common_CheckTextBox2(txtBD_Ten, "Tên người bị kiện", zone_message_name))
                                            return false;
                                        else {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtBD_Ten, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Tên người bị kiện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtBD_Ten.focus();
                                                return false;
                                            }
                                        }

                                        var txtBD_CMND = document.getElementById('<%=txtBD_CMND.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_CMND.value)) {
                                            if (!Common_CheckTextBox2(txtBD_CMND, "CMND/ Thẻ căn cước/ Hộ chiếu của người bị kiện", zone_message_name))
                                                return false;
                                            else {
                                                soluongkytu = 50;
                                                if (!Common_CheckLengthString(txtBD_CMND, soluongkytu)) {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = "CMND/ Thẻ căn cước/ Hộ chiếu của người bị kiện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                    txtBD_CMND.focus();
                                                    return false;
                                                }
                                            }
                                        }

                                        //-----------------------------
                                        var CurrYear = '<%=CurrYear%>';
                                        var txtBD_Ngaysinh = document.getElementById('<%=txtBD_Ngaysinh.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_Ngaysinh.value)) {
                                            var now = new Date();
                                            var temp = txtBD_Ngaysinh.value.split('/');
                                            temp = new Date(temp[2], temp[1] - 1, temp[0]);
                                            if (temp > now) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = 'Ngày sinh của người bị kiện phải nhỏ hơn hoặc bằng ngày hiện tại!';
                                                txtBD_Ngaysinh.focus();
                                                return false;
                                            }
                                        }
                                        var txtBD_Namsinh = document.getElementById('<%=txtBD_Namsinh.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_Namsinh.value)) {
                                            var nam_sinh = parseInt(txtBD_Namsinh.value);
                                            if (nam_sinh > CurrYear) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = 'Năm sinh của người bị kiện không được phép lớn hơn năm: ' + CurrYear;
                                                txtBD_Namsinh.focus();
                                                return false;
                                            }
                                        }
                                        //-----------------------------
                                        if (!validate_quoctich_BD())
                                            return false;
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function Validate_BiDon_CoQuan() {
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);
                                        var soluongkytu = 250;

                                        //-------------------------------   
                                        var ddlLoaiBidon = document.getElementById('<%=ddlLoaiBidon.ClientID%>');
                                        var loai_cq_value = ddlLoaiBidon.options[ddlLoaiBidon.selectedIndex].value;
                                        var loai_cq_text = "";
                                        if (loai_cq_value == 2)
                                            loai_cq_text = "cơ quan bị kiện";
                                        else if (loai_cq_value == 3)
                                            loai_cqt_text = "tổ chức bị kiện";
                                        //-------------------------------  
                                        var txtBD_Ten = document.getElementById('<%=txtBD_Ten.ClientID%>');
                                        if (!Common_CheckTextBox2(txtBD_Ten, "Tên " + loai_cq_text, zone_message_name))
                                            return false;

                                        soluongkytu = 250;
                                        if (!Common_CheckLengthString(txtBD_Ten, soluongkytu)) {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = "Tên " + loai_cq_text + " không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                            txtBD_Ten.focus();
                                            return false;
                                        }
                                        //----------------------
                                        var txtBD_NDD_ten = document.getElementById('<%=txtBD_Ten.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_NDD_ten.value)) {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtBD_NDD_ten, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Tên người đại diện không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtBD_NDD_ten.focus();
                                                return false;
                                            }
                                        }
                                        //----------------------
                                        var txtBD_NDD_Chucvu = document.getElementById('<%=txtBD_NDD_Chucvu.ClientID%>');
                                        if (Common_CheckEmpty(txtBD_NDD_Chucvu.value)) {
                                            soluongkytu = 250;
                                            if (!Common_CheckLengthString(txtBD_NDD_Chucvu, soluongkytu)) {
                                                zone_message.style.display = "block";
                                                zone_message.innerText = "Chức vụ không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                                txtBD_NDD_Chucvu.focus();
                                                return false;
                                            }
                                        }
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                </script>

                                <script>

                                    function GetLoaiTaiKhoan() {
                                        var rb = document.getElementById("<%=rdUyQuyen.ClientID%>");
                                        var inputs = rb.getElementsByTagName('input');
                                        var flag = false;
                                        var selected;
                                        for (var i = 0; i < inputs.length; i++) {
                                            if (inputs[i].checked) {
                                                selected = inputs[i];
                                                flag = true;
                                                break;
                                            }
                                        }
                                        if (flag)
                                            return selected.value;
                                    }

                                    function GetValueRadioList(control_client_id) {
                                        var rb = document.getElementById(control_client_id);
                                        var inputs = rb.getElementsByTagName('input');
                                        var flag = false;
                                        var selected;
                                        for (var i = 0; i < inputs.length; i++) {
                                            if (inputs[i].checked) {
                                                selected = inputs[i];
                                                flag = true;
                                                break;
                                            }
                                        }
                                        if (flag)
                                            return selected.value;
                                    }
                                </script>

                                <script>
                                    function validate_quoctich_ND() {
                                        var QuocTichVN = '<%=QuocTichVN%>';
                                        var zone_message_name = 'zone_message';
                                        var zone_message = document.getElementById(zone_message_name);

                                        //--------------------------------
                                        var ddlND_Quoctich = document.getElementById('<%=ddlND_Quoctich.ClientID%>');
                                        var value_change = ddlND_Quoctich.options[ddlND_Quoctich.selectedIndex].value;
                                        if (value_change == "") {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = 'Bạn chưa chọn mục " Quốc tịch của người khởi kiện". Hãy kiểm tra lại!';
                                            ddlND_Quoctich.focus();
                                            return false;
                                        }
                                        //-----------------------------------------
                                        if (value_change == QuocTichVN) {
                                            var chkND_ONuocNgoai = document.getElementById('<%=chkND_ONuocNgoai.ClientID%>');
                                            if (!chkND_ONuocNgoai.checked) {
                                                //--------check nhap ho khau tam tru---------
                                                var ddlTamTru_Tinh = document.getElementById('<%=dropTinh_TamTru.ClientID%>');
                                                var ddlTamTru_Huyen = document.getElementById('<%=dropQuanHuyen_TamTru.ClientID%>');
                                                value_change = ddlTamTru_Tinh.options[ddlTamTru_Tinh.selectedIndex].value;
                                                if (value_change == "0") {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = 'Bạn chưa chọn mục "Nơi cư trú của người khởi kiện". Hãy kiểm tra lại!';
                                                    ddlTamTru_Tinh.focus();
                                                    return false;
                                                }
                                                value_change = ddlTamTru_Huyen.options[ddlTamTru_Huyen.selectedIndex].value;
                                                if (value_change == "0") {
                                                    zone_message.style.display = "block";
                                                    zone_message.innerText = 'Bạn chưa chọn mục "Quận/Huyện nơi cư trú hiện tại của người khởi kiện". Hãy kiểm tra lại!';
                                                    ddlTamTru_Huyen.focus();
                                                    return false;
                                                }

                                            }
                                        }
                                        var txtND_TTChitiet = document.getElementById('<%=txtND_TTChitiet.ClientID%>');
                                        if (!Common_CheckTextBox2(txtND_TTChitiet, "Địa chỉ chi tiết của người khởi kiện", 'zone_message'))
                                            return false;
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function validate_quoctich_BD() {
                                        var zone_message = document.getElementById('zone_message');
                                        var QuocTichVN = '<%=QuocTichVN%>';
                                        //--------------------------------
                                        var ddlBD_Quoctich = document.getElementById('<%=ddlBD_Quoctich.ClientID%>');
                                        var value_change = ddlBD_Quoctich.options[ddlBD_Quoctich.selectedIndex].value;
                                        if (value_change == "") {
                                            zone_message.style.display = "block";
                                            zone_message.innerText = 'Bạn chưa chọn mục " Quốc tịch của người bị kiện". Hãy kiểm tra lại!';
                                            ddlBD_Quoctich.focus();
                                            return false;
                                        }
                                        var txtBD_Tamtru_Chitiet = document.getElementById('<%=txtBD_Tamtru_Chitiet.ClientID%>');
                                        if (!Common_CheckTextBox2(txtBD_Tamtru_Chitiet, "Địa chỉ chi tiết của người bị kiện", 'zone_message'))
                                            return false;
                                        //-----------------------
                                        zone_message.style.display = "none";
                                        return true;
                                    }
                                    function ShowSuccesMsg(msgcontent) {
                                        //var zone_message = document.getElementById('zone_message');
                                        // return Common_ShowMessageZone(msgcontent, 'zone_message');
                                    }

                                </script>

                                <!---------------FILE UPLOAD-------------------->
                                <script type="text/javascript">
                                    var count_file = 0;
                                    function VerifyPDFCallBack(rv) {
                                    }

                                    function exc_verify_pdf1() {
                                        var prms = {};
                                        var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
                                        prms["SessionId"] = "";
                                        prms["FileName"] = document.getElementById("file1").value;

                                        var json_prms = JSON.stringify(prms);

                                        vgca_verify_pdf(json_prms, VerifyPDFCallBack);
                                    }

                                    function SignFileCallBack1(rv) {
                                        var received_msg = JSON.parse(rv);
                                        if (received_msg.Status == 0) {
                                            var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');
                                            var file_name = received_msg.FileName;
                                            var file_path = received_msg.FileServer;

                                            var new_item = document.createElement("li");
                                            new_item.innerHTML = file_name;
                                            hddFileKySo.value = file_path;

                                            $("#<%= cmdThemFileTL.ClientID %>").click();
                                        }
                                        else {
                                            document.getElementById("_signature").value = received_msg.Message;
                                        }
                                    }

                                    //metadata có kiểu List<KeyValue> 
                                    //KeyValue là class { string Key; string Value; }
                                    function exc_sign_file1() {
                                        var prms = {};
                                        var scv = [{ "Key": "abc", "Value": "abc" }];
                                        var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
                                        prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
                                        prms["SessionId"] = "";
                                        prms["FileName"] = "";
                                        prms["MetaData"] = scv;
                                        var json_prms = JSON.stringify(prms);
                                        vgca_sign_file(json_prms, SignFileCallBack1);
                                    }
                                    function RequestLicenseCallBack(rv) {
                                        var received_msg = JSON.parse(rv);
                                        if (received_msg.Status == 0) {
                                            document.getElementById("_signature").value = received_msg.LicenseRequest;
                                        } else {
                                            alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                                        }
                                    }
                                </script>
                                <script>
                                    function LoadDsDuongSu() {
                                        //alert('load ds duong su khac');
                                        $("#<%= cmdLoadDsDuongSu.ClientID %>").click();
                                    }
                                    function LoadDsNguyenDonKhac() {
                                        // alert('load ds nguyen don khac');
                                        $("#<%= cmdLoadDsNguyenDonKhac.ClientID %>").click();
                                    }
                                    function LoadDsBiDonKhac() {
                                        // alert('load ds bi don khác');
                                        $("#<%= cmdLoadDsBiDonKhac.ClientID %>").click();
                                    }
                                    
                                </script>
                                <script>
                                    function SetTitleLoaiQDHC() {
                                        var zone_loaiqdhc = document.getElementById('zone_loaiqdhc');
                                        var dropLoaiQDHanhChinh = document.getElementById('<%= dropLoaiQDHanhChinh.ClientID%>');
                                        if (dropLoaiQDHanhChinh!=null) {
                                            var value_change = dropLoaiQDHanhChinh.options[dropLoaiQDHanhChinh.selectedIndex].value;

                                            // alert(value_change);
                                            var span_soqd = document.getElementById('span_soqd');
                                            var span_ngayqd = document.getElementById('span_ngayqd');
                                            if (value_change != 0) {
                                                span_soqd.className = span_ngayqd.className = "batbuoc";
                                                span_soqd.innerText = span_ngayqd.innerText = "*";
                                                zone_loaiqdhc.innerText = ": " + dropLoaiQDHanhChinh.options[dropLoaiQDHanhChinh.selectedIndex].text;
                                            } else {
                                                span_soqd.className = span_ngayqd.className = "";
                                                span_soqd.innerText = span_ngayqd.innerText = "";
                                                zone_loaiqdhc.innerText = '......';
                                            }
                                        }
                                        
                                    }
                                    SetTitleLoaiQDHC();
                                </script>
                                <script>
                                    function show_popup_in(donkhoikienID) {
                                        var para = "";
                                        var pageURL = "/Personnal/InBC.aspx";
                                        if (donkhoikienID > 0)
                                            pageURL += "?dkkID=" + donkhoikienID;

                                        var page_width = 880;
                                        var page_height = 550;
                                        var left = (screen.width / 2) - (page_width / 2);
                                        var top = (screen.height / 2) - (page_height / 2);
                                        var targetWin = window.open(pageURL, 'In đơn khởi kiện'
                                            , 'toolbar=no,scrollbars=yes,resizable=no'
                                            + ', width = ' + page_width
                                            + ', height=' + page_height + ', top=' + top + ', left=' + left);
                                        return targetWin;
                                    }

                                    function show_popup_by_loaids(loai_ds) {

                                        var para = "";
                                        if (!validate_toaan())
                                            return false;
                                        //--------------------------------------
                                        var loai_vuviec = document.getElementById('<%=hddLinhVucVuViec.ClientID%>').value;
                                        if (loai_ds == "BIDON") {
                                            if (!Validate_BiDon())
                                                return false;
                                        }
                                        else {
                                            if (!Validate_NguyenDon())
                                                return false;
                                        }
                                        // alert(loai_ds);
                                        var hddDonKKID = document.getElementById('<%=hddDonKKID.ClientID%>');
                                        
                                        var pageURL = "/Personnal/Duongsu.aspx";

                                        para = "?loaivv=" + loai_vuviec;
                                        if (hddDonKKID.value != "0")
                                            para += "&dkkID=" + hddDonKKID.value;
                                        if (para.length > 0)
                                            para += "&loaids=" + loai_ds;
                                        pageURL += para;

                                        var page_width = 880;
                                        var page_height = 550;
                                        var left = (screen.width / 2) - (page_width / 2);
                                        var top = (screen.height / 2) - (page_height / 2);

                                        var targetWin = window.open(pageURL, 'Đương sự'
                                            , 'toolbar=no,scrollbars=yes,resizable=no'
                                            + ', width = ' + page_width
                                            + ', height=' + page_height + ', top=' + top + ', left=' + left);
                                        return targetWin;
                                    }
                                    //show_popup_by_loaidsNguoiuyquyen

                                    

                                    function show_popup_by_loaidsNguoiuyquyen(loai_ds,idEdit='0') {

                                        var para = "";
                                        if (!validate_toaan())
                                            return false;
                                        //--------------------------------------
                                        var loai_vuviec = document.getElementById('<%=hddLinhVucVuViec.ClientID%>').value;
                                        if (loai_ds == "BIDON") {
                                            if (!Validate_BiDon())
                                                return false;
                                        }
                                        else {
                                            if (!Validate_NguyenDon())
                                                return false;
                                        }
                                        // alert(loai_ds);
                                        var hddDonKKID = document.getElementById('<%=hddDonKKID.ClientID%>');

                                        var pageURL = "/Personnal/DuongsuNEW.aspx";

                                        para = "?loaivv=" + loai_vuviec;
                                        if (hddDonKKID.value != "0")
                                            para += "&dkkID=" + hddDonKKID.value;
                                        if (para.length > 0)
                                            para += "&loaids=" + loai_ds;
                                        para += "&idEdit=" + idEdit;
                                        pageURL += para;

                                        var page_width = 880;
                                        var page_height = 700;
                                        var left = (screen.width / 2) - (page_width / 2);
                                        var top = (screen.height / 2) - (page_height / 2);

                                        var targetWin = window.open(pageURL, 'Đương sự'
                                            , 'toolbar=no,scrollbars=yes,resizable=no'
                                            + ', width = ' + page_width
                                            + ', height=' + page_height + ', top=' + top + ', left=' + left);
                                        return targetWin;
                                    }
                                </script>


                                <script>
                                    function hide_zone_message() {
                                        var today = new Date();
                                        var zone = document.getElementById('zone_message');
                                        if (zone.style.display != "") {
                                            zone.style.display = "none";
                                            zone.innerText = "";
                                        }
                                        var t = setTimeout(hide_zone_message, 9000);
                                    }
                                    hide_zone_message();
                                </script>
                            </asp:Panel>
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btn_saveFileAttach" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                        <ProgressTemplate>
                            <div class="processmodal">
                                <div class="processcenter">
                                    <img src="/UI/img/process.gif" />
                                </div>
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>
        </div>
    </div>
    <style>
        .processcenter img {
            height: 50px;
            width: 50px;
        }

        .luufile {
            background: #e03a39;
            color: white;
            padding: 3px 22px 3px 22px;
            font-size: 13px;
            text-transform: none;
        }
        .btnUpload{
            padding : 4px 8px 4px 8px;
        }

        .file_attact_ss {
            border: none;
            cursor: pointer;
        }
    </style>
</asp:Content>

<%--To validate multiple files with jQuery + asp:CustomValidator a size up to 10MB
    function upload(sender, args) {
        args.IsValid = true;
        var maxFileSize = 10 * 1024 * 1024; // 10MB
        var CurrentSize = 0;
        var fileUpload = $("[id$='fuUpload']");
        for (var i = 0; i < fileUpload[0].files.length; i++) {
            CurrentSize = CurrentSize + fileUpload[0].files[i].size;          
        }
        args.IsValid = CurrentSize < maxFileSize;
    }
asp:FileUpload runat="server" AllowMultiple="true" ID="fuUpload" />
 <asp:LinkButton runat="server" Text="Upload" OnClick="btnUpload_Click" 
      CausesValidation="true" ValidationGroup="vgFileUpload"></asp:LinkButton>
 <asp:CustomValidator ControlToValidate="fuUpload" ClientValidationFunction="upload" 
      runat="server" ErrorMessage="Error!" ValidationGroup="vgFileUpload"/>--%>


