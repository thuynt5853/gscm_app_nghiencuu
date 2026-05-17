<%@ Page MaintainScrollPositionOnPostback="true" Language="C#" AutoEventWireup="true" CodeBehind="DuongSuNEW.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.DuongSuNEW" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../UI/css/style.css" rel="stylesheet" />
    <link href="../UI/css/Table.css" rel="stylesheet" />
    <link href="../UI/css/Paging.css" rel="stylesheet" />
    <link href="../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../UI/css/chosen.css" rel="stylesheet" />

    <link href="../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../UI/js/jquery-3.3.1.js"></script>
    <script src="../UI/js/jquery-ui.min.js"></script>

    <script src="../UI/js/Common.js"></script>

    <script src="../UI/js/chosen.jquery.js"></script>
    <script src="../UI/js/init.js"></script>
    <script src="../UI/js/jquery.enhsplitter.js"></script>

    <title>Đương sự</title>
    <style>
        .table1 tr, td {
            padding-left: 0px;
        }

        .boder {
            padding-top: 20px;
            padding-bottom: 20px;
            padding-left: 2%;
            float: left;
        }

        .content_popup {
            margin: 15px 1.5%;
            float: left;
            position: relative;
            overflow: unset;
            overflow-y: auto;
        }

        body {
            min-width: 100% !important;
            background-color: white !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddReloadParent" runat="server" />
        <asp:HiddenField ID="hddDKK" Value="0" runat="server" />
        <asp:HiddenField ID="hddVuAn" Value="0" runat="server" />

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div style="margin-left: 3%; float: left; margin-top: 15px; margin-bottom: 15px;">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true" ClientIDMode="AutoID">
                <ContentTemplate>
                    <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rptCapNhat_ItemDataBound">
                        <ItemTemplate>
                            <asp:HiddenField ID="hddDuongSuID" runat="server" />
                            <div class="box_nd" style="background: white;">
                                <div class="boxchung">
                                    <h4 class="tleboxchung">
                                        <asp:Literal ID="lttTieuDe" Text="Thông tin người ủy quyền" runat="server"></asp:Literal></h4>
                                    <asp:DropDownList ID="dropLoaiDon" runat="server" Visible="false">
                                    </asp:DropDownList>

                                    <div class="boder">
                                        <div id="zone_message"></div>
                                        <div class="msg_warning" style="float: left;">
                                            Những thông tin có dấu <span class="batbuoc">*</span>  là phần bắt buộc
                                        </div>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 115px;">Là<span class="batbuoc">*</span></td>
                                                <td style="width: 225px;">
                                                    <asp:DropDownList ID="ddlLoaiNguyendon"
                                                        CssClass="chosen-select clddlLoaiNguyendon" runat="server" Width="190px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiNguyendon_SelectedIndexChanged" ClientIDMode="AutoID">
                                                        <asp:ListItem Value="1" Text="Cá nhân"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="Cơ quan"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Tổ chức"></asp:ListItem>
                                                    </asp:DropDownList></td>
                                                <td style="width: 115px;">Tư cách tố tụng
                                        <span class="batbuoc">*</span></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTucachTotung"
                                                        CssClass="chosen-select" runat="server" Width="250px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblHoTen" runat="server" Text="Họ tên"></asp:Label><span class="batbuoc">*</span></td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtTenDuongSu" CssClass="textbox cltxtTenDuongSu"
                                                        runat="server" Width="580px"></asp:TextBox></td>
                                            </tr>
                                            <asp:Panel ID="pnNDTochuc" runat="server" Visible="false">
                                                <tr>
                                                    <td>Địa chỉ</td>
                                                    <td>
                                                        <asp:DropDownList ID="dropToChuc_Tinh" runat="server"
                                                            AutoPostBack="true" OnSelectedIndexChanged="dropToChuc_Tinh_SelectedIndexChanged"
                                                            CssClass="chosen-select" placeholder="Tỉnh" Width="190px" ClientIDMode="AutoID">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:Literal ID="lttLabelQuanHuyen" runat="server" Text="Quận/ Huyện"></asp:Literal></td>
                                                    <td>
                                                        <asp:DropDownList ID="dropToChuc_QuanHuyen" runat="server"
                                                            CssClass="chosen-select" placeholder="Quận/Huyện" Width="250px">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Địa chỉ chi tiết</td>
                                                    <td colspan="3">
                                                        <asp:TextBox ID="txtToChuc_DiaChiCT" CssClass="textbox"
                                                            placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                            runat="server" Width="580px" MaxLength="250"></asp:TextBox></td>
                                                </tr>
                                                <!---------------------------------------->
                                                <tr>
                                                    <td>Người đại diện</td>
                                                    <td>
                                                        <asp:TextBox ID="txtToChuc_NguoiDD"
                                                            CssClass="textbox cltxtToChuc_NguoiDD" runat="server" Width="178px"
                                                            MaxLength="250"></asp:TextBox></td>
                                                    <td>Chức vụ</td>
                                                    <td>
                                                        <asp:TextBox ID="txtToChuc_NguoiDD_ChucVu"
                                                            CssClass="textbox" runat="server" Width="237px"
                                                            MaxLength="250"></asp:TextBox></td>
                                                </tr>
                                            </asp:Panel>
                                            <tr>
                                                <td>Số CMND/ Thẻ căn cước/ Hộ chiếu
                                                <asp:Literal ID="lttCheckCMND" runat="server"></asp:Literal>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtND_CMND" CssClass="textbox cltxtND_CMND"
                                                        runat="server" Width="178px" MaxLength="250"></asp:TextBox></td>
                                                <td>Giới tính</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select"
                                                        runat="server" Width="250px">
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
                                                            runat="server" Width="190px" AutoPostBack="True" OnSelectedIndexChanged="ddlND_Quoctich_SelectedIndexChanged" ClientIDMode="AutoID">
                                                        </asp:DropDownList></td>
                                                    <td>Ngày sinh</td>
                                                    <td>
                                                        <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="textbox cltxtND_Ngaysinh" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <span style="<%=WidthCellNamSinh%>">Năm sinh</span><asp:Literal ID="lttValidateNamSinh" runat="server"></asp:Literal>

                                                        <asp:TextBox ID="txtND_Namsinh" CssClass="textbox cltxtND_Namsinh"
                                                            onkeypress="return isNumber(event)"
                                                            AutoPostBack="true" OnTextChanged="txtND_Namsinh_TextChanged"
                                                            runat="server" Width="50px" MaxLength="4"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td colspan="3">
                                                        <asp:CheckBox ID="chkONuocNgoai" runat="server"
                                                            AutoPostBack="true" OnCheckedChanged="chkONuocNgoai_CheckedChanged"
                                                            Text=" Quốc tịch Việt Nam nhưng sinh sống ở nước ngoài" ClientIDMode="AutoID" />
                                                    </td>
                                                </tr>

                                                <!------------------------------->
                                                <asp:Panel ID="pnTamTru" runat="server">
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblNoiCutru" runat="server" Text="Nơi cư trú"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="dropCaNhan_TamTru_Tinh" runat="server"
                                                                AutoPostBack="true" OnSelectedIndexChanged="dropCaNhan_TamTru_Tinh_SelectedIndexChanged"
                                                                CssClass="chosen-select" placeholder="Tỉnh" Width="190px" ClientIDMode="AutoID">
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblQuanHuyen" runat="server" Text="Quận/ Huyện"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="dropCaNhan_TamTru_QuanHuyen" runat="server"
                                                                CssClass="chosen-select" placeholder="Quận/Huyện" Width="250px">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Địa chỉ chi tiết<span class="batbuoc">*</span></td>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txtCaNhan_TamTru_DiaChiCT" CssClass="textbox cltxtCaNhan_TamTru_DiaChiCT"
                                                                placeholder="Ghi rõ địa chỉ chi tiết. VD: Số nhà … Ấp/ thôn .... đường/phố … phường/xã …"
                                                                runat="server" Width="580px" MaxLength="250"></asp:TextBox></td>
                                                    </tr>
                                                    <!---------------------------------------->
                                                    <tr>
                                                        <td></td>
                                                        <td colspan="3"><i class='warning_dc'>(Địa chỉ này dùng để nhận các văn bản, thông báo từ Tòa án)</i></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Nơi làm việc</td>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txtCaNhan_DiaChiCoQuan" CssClass="textbox cltxtCaNhan_DiaChiCoQuan"
                                                                runat="server" Width="580px"></asp:TextBox></td>
                                                    </tr>
                                                </asp:Panel>

                                            </asp:Panel>
                                            <tr>
                                                <td>Email</td>
                                                <td>
                                                    <asp:TextBox ID="txtEmail" CssClass="textbox cltxtEmail"
                                                        runat="server" Width="178px" MaxLength="250"></asp:TextBox></td>
                                                <td>Điện thoại</td>
                                                <td>
                                                    <asp:TextBox ID="txtDienthoai" runat="server" onkeypress="return isNumber(event)"
                                                        CssClass="textbox" Width="90px"></asp:TextBox>
                                                    <span style="margin-right: 2px;">Fax</span>
                                                    <asp:TextBox ID="txtFax" runat="server" onkeypress="return isNumber(event)"
                                                        CssClass="textbox" Width="100px"></asp:TextBox>
                                                </td>
                                            </tr>

                                        </table>
                                    </div>
                                </div>

                            </div>

                        </ItemTemplate>

                    </asp:Repeater>

                </ContentTemplate>
            </asp:UpdatePanel>


            <div style="text-align: center;">
                <div class="CSSTableGenerator">
                    <table>

                        <tr id="row_header0">
                            <td style="width: 20px;">TT</td>
                            <td>Họ và tên</td>
                            <td>Số CMND/CCCD/Hộ chiếu</td>
                            <td>Tư cách tố tụng</td>
                            <td style="width: 70px;">Thao tác</td>
                        </tr>
                        <asp:Repeater ID="rptNguyenDonKhac" runat="server" OnItemCommand="rptNguyenDonKhac_ItemCommand" Visible="true" ClientIDMode="AutoID">
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
                                    <td>
                                        <div style="text-align: justify; float: left;">
                                            <%#Eval("SOCMND") %>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="text-align: justify; float: left;">
                                            <%#Eval("TuCachToTung") %>
                                        </div>
                                    </td>
                                    <asp:Panel ID="pnXoaFile" runat="server">
                                        <td>
                                            <div style="text-align: center;">
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </div>
                                        </td>
                                    </asp:Panel>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                </div>

                <div style="text-align: center;">
                    <div class="msg_thongbao">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                    </div>
                </div>

                <div style="text-align: center;">
                    <asp:Button ID="btnAddNguoiUyQuyen" runat="server" CssClass="buttoninput bg_do" Text="Thêm người ủy quyền" OnClick="btnAddNguoiUyQuyen_Click" />
                    <asp:Button ID="btnRemoveNguoiUyQuyen" runat="server" CssClass="buttoninput bg_do" Text="Xóa người ủy quyền" OnClick="btnRemoveNguoiUyQuyen_Click" />

                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput bg_do" Text="Lưu" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                    <asp:Button ID="cmdClose" runat="server" CssClass="buttoninput bg_do" Text="Đóng" OnClick="cmdClose_Click" />
                </div>

            </div>
        </div>
        <script>
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.loadNguoiUyQuyen();
                };
                window.close();
            }


        </script>
        <script>
            function validate() {
                var zone_message_name = 'zone_message';
                var zone_message = document.getElementById(zone_message_name);
                var soluongkytu = 250;
                var temp = "";
                let valid = true;
                $('.box_nd').each(function () {

                    var ddlLoaiNguyendon = $(this).find('.clddlLoaiNguyendon')[0];
                    var value_change = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].value;

                    if (value_change == 1) {
                        //
                        var txtTenDuongSu = $(this).find('.cltxtTenDuongSu')[0];
                        if (!Common_CheckTextBox2(txtTenDuongSu, "Tên đương sự", zone_message_name))
                            return valid = false;
                        if (!validate_canhan(this))
                            return valid = false;
                    }
                    else {
                        var txtTenDuongSu = $(this).find('.cltxtTenDuongSu')[0];
                        if (!Common_CheckTextBox2(txtTenDuongSu, "Tên cơ quan/tổ chức", zone_message_name))
                            return valid = false;
                        if (!validate_Tochuc(this))
                            return valid = false;
                    }
                    //cltxtEmail
                    var txtEmail = $(this).find('.cltxtEmail')[0];
                    if (Common_CheckEmpty(txtEmail.value)) {
                        var string_Email = txtEmail.value;
                        var retval = false;
                        var _pattern = /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/;
                        if (!string_Email.match(_pattern)) {
                            zone_message.style.display = "block";
                            zone_message.innerText = "Định dạng email không hợp lệ.Hãy kiểm tra lại!";

                            txtEmail.focus();
                            return valid = false;
                        }

                        var soluongkytu = 250;
                        if (!Common_CheckLengthString(txtEmail, soluongkytu)) {
                            zone_message.style.display = "block";
                            zone_message.innerText = "Email không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                            txtEmail.focus();
                            return valid = false;
                        }
                    }

                    //cltxtCaNhan_DiaChiCoQuan
                    if (value_change == 1) {
                        var txtCaNhan_DiaChiCoQuan = $(this).find('.cltxtCaNhan_DiaChiCoQuan')[0];
                        if (Common_CheckEmpty(txtCaNhan_DiaChiCoQuan.value)) {
                            soluongkytu = 500;
                            if (!Common_CheckLengthString(txtCaNhan_DiaChiCoQuan, soluongkytu)) {
                                zone_message.style.display = "block";
                                zone_message.innerText = "Mục 'Nơi làm việc' không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                txtCaNhan_DiaChiCoQuan.focus();
                                return valid = false;
                            }
                        }
                    }
                })

                return valid;
            }
            //cltxtToChuc_NguoiDD
            function validate_Tochuc(el) {
                var zone_message_name = 'zone_message';
                var zone_message = document.getElementById(zone_message_name);
                var txtToChuc_NguoiDD = $(el).find('.cltxtToChuc_NguoiDD')[0];
                if (Common_CheckEmpty(txtToChuc_NguoiDD.value)) {
                    var soluongkytu = 250;
                    if (!Common_CheckLengthString(txtToChuc_NguoiDD, soluongkytu)) {
                        zone_message.style.display = "block";
                        zone_message.innerText = "Tên người đại diện cho cơ quan/tổ chức không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                        txtToChuc_NguoiDD.focus();
                        return false;
                    }
                }
                return true;
            }
            function validate_canhan(el) {
                var zone_message_name = 'zone_message';
                var zone_message = document.getElementById(zone_message_name);

                var ddlLoaiNguyendon = $(el).find('.clddlLoaiNguyendon')[0];
                var value_change = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].value;

                var soluongkytu = 250;
                var txtND_CMND = $(el).find('.cltxtND_CMND')[0];
                var TypeDuongSu = 'UYQUYEN';
                console.log(TypeDuongSu);
                if (TypeDuongSu == 'NGUYENDON' || TypeDuongSu == 'UYQUYEN' || TypeDuongSu == 'NGUOIUYQUYEN') {
                    if (value_change == 1) {
                        if (!Common_CheckTextBox2(txtND_CMND, "Số CMND/ Thẻ căn cước/ Hộ chiếu", zone_message_name))
                            return false;
                        else {
                            soluongkytu = 50;
                            if (!Common_CheckLengthString(txtND_CMND, soluongkytu)) {
                                zone_message.style.display = "block";
                                zone_message.innerText = "CMND/ Thẻ căn cước/ Hộ chiếu  không thể nhập quá " + soluongkytu + " ký tự. Hãy kiểm tra lại!";
                                txtND_CMND.focus();
                                return false;
                            }
                        }
                    }
                }

                var txtND_Ngaysinh = $(el).find('.cltxtND_Ngaysinh')[0];
                if (Common_CheckEmpty(txtND_Ngaysinh.value)) {
                    if (!CheckDateTimeControl2(txtND_Ngaysinh, 'Ngày sinh', zone_message_name))
                        return false;
                }
                //-----------------------------
                var CurrYear = new Date().getFullYear();
                var txtND_Namsinh = $(el).find('.cltxtND_Namsinh')[0];

                var TypeDuongSu = 'UYQUYEN';
                if (TypeDuongSu == 'NGUYENDON' || TypeDuongSu == 'UYQUYEN' || TypeDuongSu == 'NGUOIUYQUYEN') {
                    if (!Common_CheckTextBox2(txtND_Namsinh, "Năm sinh", zone_message_name))
                        return false;
                }
                if (Common_CheckEmpty(txtND_Namsinh.value)) {
                    var nam_sinh = parseInt(txtND_Namsinh.value);
                    if (nam_sinh > CurrYear) {
                        zone_message.style.display = "block";
                        zone_message.innerText = 'Năm sinh không được phép lớn hơn năm: ' + CurrYear;
                        txtND_Namsinh.focus();
                        return false;
                    }
                }//
                var txtCaNhan_TamTru_DiaChiCT = $(el).find('.cltxtCaNhan_TamTru_DiaChiCT')[0];
                if (!Common_CheckTextBox2(txtCaNhan_TamTru_DiaChiCT, "Địa chỉ chi tiết nơi cư trú", zone_message_name))
                    return false;

                return true;
            }
            function hide_zone_message() {
                var today = new Date();
                var zone = document.getElementById('zone_message');
                if (zone.style.display != "")
                    zone.style.display = "none";
                var t = setTimeout(hide_zone_message, 9000);
            }
            hide_zone_message();



        </script>


        <script>
            function pageLoad(sender, args) {
                $(function () {
                    var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';
                    $("[id$=txtToaAn]").autocomplete({
                        source: function (request, response) {
                            $.ajax({
                                url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                                success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                            });
                        },
                        select: function (e, i) { $("[id$=hddToaAnID]").val(i.item.val); }, minLength: 1
                    });
                });

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
        <script>
                  <%--//-------------------------------------------
                  var ddlLoaiNguyendon = document.getElementById('<%=ddlLoaiNguyendon.ClientID%>');
                  var value_change = ddlLoaiNguyendon.options[ddlLoaiNguyendon.selectedIndex].value;
                  var TypeDuongSu = '<%=TypeDuongSu%>';
                  var lttCheckCMND = document.getElementById('<%=lttCheckCMND.ClientID%>');
                  var batbuocnhap = "<span class='batbuoc' id='span_CMND'>*</span>";
                  alert(TypeDuongSu + ", " + value_change)
                  if (TypeDuongSu == 'NGUYENDON'|| TypeDuongSu == 'UYQUYEN' || TypeDuongSu == 'NGUOIUYQUYEN') {
                      if (value_change == "1")
                          lttCheckCMND.innerText = batbuocnhap;
                      else
                          lttCheckCMND.innerText = "";
                  }
                  else
                      lttCheckCMND.innerText = "";--%>
</script>
    </form>
</body>
</html>
