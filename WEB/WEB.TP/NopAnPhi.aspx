<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NopAnPhi.aspx.cs" Inherits="WEB.TP.NopAnPhi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <%--<link href="../../../../UI/css/chosen.css" rel="stylesheet" />--%>
    <link href="UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <title>Nộp án phí</title>
    <style>
        .content_body {
            width: 96%;
            margin: 20px 2%;
        }

        .cell_label {
            margin-left: 5px;
        }

        .buttoninput {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            background: #d02629;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            border: medium none;
        }

        .buttondisable {
            float: left;
            margin-right: 8px;
            padding: 5px 10px 6px 10px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
        }

        .bg_Disable {
            background-color: #fbf9f3;
        }

        .remove_bg_Disable {
            background-color: unset;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="Ajax_Manager_Updata" runat="server">
            <ContentTemplate>
                <div class="content_form">
                    <asp:HiddenField ID="hdd_matb" runat="server" Value="" />
                    <asp:HiddenField ID="hddDuongsu" runat="server" Value="" />
                    <asp:HiddenField ID="hddid" runat="server" Value="0" />
                    <asp:HiddenField ID="hdd_case" runat="server" Value="0" />
                    <asp:HiddenField ID="bmID" runat="server" Value="0" />
                    <asp:HiddenField ID="hdd_SOTL" runat="server" Value="" />
                    <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
                    <asp:HiddenField ID="hi_check_kyso" runat="server" Value="0" />
                    <asp:HiddenField ID="hdd_tp_id" runat="server" Value="" />
                    <div class="content_body" style="width: 750px; margin-top: 0px;">
                        <div class="content_form_head" style="width: 750px;">
                            <div class="content_form_head_title">
                                <asp:Label ID="lbl_title_anphi" runat="server" Text="Nộp án phí"></asp:Label>
                            </div>
                            <div class="content_form_head_right"></div>
                        </div>
                        <div class="content_form_body" style="width: 750px;">
                            <div id="div_NopAnPhi" runat="server">
                                <div style="width: 700px; float: left;">
                                    <div>
                                        <h4 class="tleboxchung">1.Thông tin người nộp án phí</h4>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Người nộp là</div>
                                    <div style="float: left;">
                                        <asp:RadioButtonList ID="rdLoaiNguoiNop" runat="server"
                                            CssClass="radio_cts" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdLoaiNguoiNop_SelectedIndexChanged">
                                            <asp:ListItem Text="Nguyên đơn" Value="1" Selected="True"></asp:ListItem>
                                            <asp:ListItem Text="Người khác" Value="0"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <%--    <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Chọn đương sự<span class="must_input">(*)</span></div>
                                    <div style="float: left; width: 240px;" id="div_duongsu" runat="server">
                                        <asp:DropDownList ID="ddlDuongSu" CssClass="chosen-select" runat="server" Width="233px">
                                        </asp:DropDownList>
                                    </div>
                                </div>--%>
                                <div style="width: 700px; float: left; margin-top: 10px; display: none;" runat="server" id="div_ddl_NopCho_DuongSu">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Nộp cho đương sự<span class="must_input">(*)</span></div>
                                    <div style="float: left; width: 556px;" runat="server">
                                        <asp:DropDownList ID="ddl_NopCho_DuongSu" CssClass="chosen-select" runat="server" Width="556px">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Họ tên<span class="must_input">(*)</span></div>
                                    <div style="float: left;" id="td_txtNguoiNop_HoTen" runat="server">
                                        <asp:TextBox ID="txtNguoiNop_HoTen" CssClass="textbox" runat="server"
                                            MaxLength="250" Width="219px"></asp:TextBox>
                                    </div>
                                    <div style="float: left;" id="div_gioitinh_namsinh" runat="server">
                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top: 6px;">
                                            <asp:Label ID="lbl_gioitinh" runat="server" Text="Giới tính"></asp:Label>
                                        </div>
                                        <div style="float: left;">
                                            <asp:DropDownList ID="dropNguoiNop_GioiTinh" CssClass="dropbox"
                                                runat="server" Width="92px">
                                                <asp:ListItem Value="1" Text="Nam" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; width: 67px; margin-right: 10px; padding-top: 6px; text-align: right;">Năm sinh</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txtNguoiNop_NamSinh" CssClass="textbox"
                                                onkeypress="return isNumber(event)" runat="server"
                                                Width="50px" MaxLength="4"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Thẻ căn cước<span runat="server" id="Span1" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNOP_SO_CCCD" CssClass="textbox"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="217px" MaxLength="20"></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 81px; text-align: right; margin-right: 10px; padding-top: 6px;">Hộ chiếu<span runat="server" id="Span2" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNOP_SO_HO_CHIEU" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="textbox" Width="219px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Số CMND<span runat="server" id="txtNguoiNop_CMND_must_input" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNop_CMND" CssClass="textbox"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="217px" MaxLength="20"></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 81px; text-align: right; margin-right: 10px; padding-top: 6px;">Điện thoại</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNop_DienThoai" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="textbox" Width="219px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Địa chỉ</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNop_Diachi" CssClass="textbox"
                                            runat="server" MaxLength="250" Width="543px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div>
                                        <h4 class="tleboxchung">2.Nộp án phí</h4>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Ngày biên lai <span class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNGAYBIENLAI" runat="server" CssClass="user" Width="216px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNGAYBIENLAI" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNGAYBIENLAI" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                    <div style="float: left; width: 90px; padding-top: 6px; text-align: right; padding-right: 10px;">Số biên lai <span class="must_input">(*)</span></span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtSoBienLai" CssClass="textbox" runat="server" Width="213px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Tạm ứng án phí<span class="must_input">(*)</span></div>
                                    <div style="float: left; position: relative;">
                                        <asp:TextBox ID="txtTamUngAP" runat="server" Enabled="false" BackColor="#f9f4e3"
                                            CssClass="textbox align_left" Width="211px" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <div style="position: absolute; left: 185px; top: 6px; color: #575151;"><span style="margin-left: 3px; font-size: 12px;">(VNĐ)</span></div>
                                    </div>
                                    <div style="float: left; width: 89px; padding-top: 6px; text-align: right; padding-right: 10px;">Người thu<span class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNGUOITHUTIEN" CssClass="user" runat="server" Width="219px"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div id="div_hoantraAnphi" runat="server">
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left;">
                                        <h4 class="tleboxchung">Thông tin người nhận hoàn trả tiền tạm ứng án phí</h4>
                                    </div>
                                </div>
                                <div runat="server" id="div_ANPHIHOANTRA" style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Số tiền <span runat="server" id="must_input_ANPHIHOANTRA" class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txt_ANPHIHOANTRA" CssClass="user" runat="server"
                                            MaxLength="250" Width="178px" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)"></asp:TextBox>
                                        <span style="margin-left: 3px; font-weight: bold;">(VNĐ)</span>
                                    </div>
                                    <div style="margin-left: 4px; float: left; width: 80px; padding-top: 0px; text-align: right; padding-right: 10px;">Ngày hoàn trả <span runat="server" id="must_input_NGAYHOANTRA" class="must_input">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txt_NGAYHOANTRA" runat="server" CssClass="user" Width="219px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txt_NGAYHOANTRA" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_NGAYHOANTRA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Người nhận là</div>
                                    <div style="float: left;">
                                        <asp:RadioButtonList ID="rdLoaiNguoiNhan" runat="server"
                                            CssClass="radio_cts" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdLoaiNguoiNhan_SelectedIndexChanged">
                                            <asp:ListItem Text="Nguyên đơn" Value="1" Selected="True"></asp:ListItem>
                                            <asp:ListItem Text="Người khác" Value="0"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>

                                <div style="width: 700px; float: left; margin-top: 10px; display: none;" runat="server" id="div_ddl_NhanCho_DuongSu">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Nhận cho đương sự<span class="must_input">(*)</span></div>
                                    <div style="float: left; width: 556px;" runat="server">
                                        <asp:DropDownList ID="ddl_NhanCho_DuongSu" CssClass="chosen-select" runat="server" Width="556px">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Họ tên<span runat="server" id="must_input_NguoiNhan_Hoten" class="must_input">(*)</span></div>
                                    <div style="float: left;" id="td_txtNguoiNhan_Hoten" runat="server">
                                        <asp:TextBox ID="txtNguoiNhan_Hoten" CssClass="textbox" runat="server"
                                            MaxLength="250" Width="219px"></asp:TextBox>
                                    </div>
                                    <div style="float: left;" id="div_gioitinh_namsinh_nhan" runat="server">
                                        <div style="float: left; width: 80px; text-align: right; margin-right: 10px; padding-top: 6px;">
                                            <asp:Label ID="lbl_gioitinh_nhan" runat="server" Text="Giới tính"></asp:Label>
                                        </div>
                                        <div style="float: left;">
                                            <asp:DropDownList ID="dropNguoiNhan_GioiTinh" CssClass="dropbox"
                                                runat="server" Width="82px">
                                                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; width: 67px; margin-right: 10px; padding-top: 6px; text-align: right;">Năm sinh</div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txtNguoiNhan_Namsinh" CssClass="textbox"
                                                onkeypress="return isNumber(event)" runat="server"
                                                Width="60px" MaxLength="4"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Thẻ căn cước<span runat="server" id="txtNguoiNhan_CCCD_must_input" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtHOANTRAAP_SO_CCCD" CssClass="textbox"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="217px" MaxLength="20"></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 81px; text-align: right; margin-right: 10px; padding-top: 6px;">Hộ chiếu<span runat="server" id="Span3" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtHOANTRAAP_SO_HO_CHIEU" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="textbox" Width="219px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Số CMND<span runat="server" id="txtNguoiNhan_CMND_must_input" class="must_input" style="color: #000000;font-weight:normal;">(*)</span></div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNhan_CMND" CssClass="textbox"
                                            onkeypress="return isNumber(event)" runat="server"
                                            Width="217px" MaxLength="20"></asp:TextBox>
                                    </div>
                                    <div style="float: left; width: 81px; text-align: right; margin-right: 10px; padding-top: 6px;">Điện thoại</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNhan_Dienthoai" runat="server"
                                            onkeypress="return isNumber(event)"
                                            CssClass="textbox" Width="219px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Email</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNhan_Email" CssClass="textbox"
                                            runat="server" Width="543px" MaxLength="250"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 6px;">Địa chỉ chi tiết</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txtNguoiNhan_DiaChiChitiet" CssClass="textbox"
                                            runat="server" MaxLength="250" Width="543px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="width: 700px; float: left; margin-top: 10px;">
                                    <div style="float: left; width: 100px; padding-top: 16px;">Ghi chú</div>
                                    <div style="float: left;">
                                        <asp:TextBox ID="txt_GHICHU_HOANTRA" CssClass="user" runat="server" TextMode="MultiLine" Width="543px" Rows="3"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 0px;">
                                <div style="float: left; font-size: 16px; margin: 10px; text-align: left; color: red; padding-left: 90px;">
                                    <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div style="width: 700px; float: left; margin-bottom: 10px;" runat="server" id="div1">
                                <div style="float: left; width: 500px; color: red;"><b>Lưu ý: Người dùng nhấn nút Gửi để gửi biên lai sang Tòa án</b></div>
                            </div>
                            <div style="width: 700px; float: left; margin-top: 0px;">
                                <%-- <div style="float: left; width: 700px; padding-top: 6px;">Tệp đính kèm</div>--%>
                                <div runat="server" id="trThemFile" visible="true" style="float: left;">
                                    <asp:HiddenField ID="hddFilePath" runat="server" />
                                    <%--           <asp:CheckBox ID="chkKySo" Checked="false" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" CssClass="chkKySo" />
                                        <style>
                                            .chkKySo {
                                                display: none;
                                            }
                                        </style>
                                        <br />--%>
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <%--    <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px; float: left;display: none;">
                                            <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                            <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                            <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                            </ul>
                                        </div>
                                        <div id="zonekythuong" style=" float: left; margin-top: 10px;">
                                            <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" Width="300px" Height="25px" CssClass="upload_kythuong" />
                                            <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" CssClass="img_load_file" />
                                        </div>--%>
                                    <br />
                                    <div runat="server" id="div_file_attach" style="width: 200px; float: left; margin-top: 0px;">
                                        <div style="float: left; width: 200px; margin-left: 0px;">
                                            <asp:HiddenField ID="hddFile" Value="0" runat="server" />
                                            <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Font-Bold="true" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                        </div>
                                        <div style="float: left; width: 200px; margin-left: 0px; margin-top: 4px;">
                                            <asp:LinkButton ID="lbtXoa" Visible="false" ForeColor="Red" Font-Bold="true" runat="server" Text="Xóa" OnClick="lbtXoa_Click"
                                                OnClientClick="return confirm('Bạn thực sự muốn file đính kèm này? ');"></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%--<style>
                                        /*20/11/2024*/
                                        .upload_kythuong {
                                            position: relative;
                                            top: 20px;
                                            left: 0px;
                                        }

                                            .upload_kythuong input {
                                                height: 25px;
                                                position: absolute;
                                                left: 0px;
                                                top: 2px;
                                            }

                                        .img_load_file {
                                            /*position: absolute;
                                                top: -3px;*/
                                        }
                                    </style>--%>
                            <div style="width: 600px; float: left; margin-top: 0px; margin-left: 100px;">
                                <div style="text-align: center;">
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <asp:Button ID="btnNBInBL" runat="server" Visible="false" CssClass="button" Text="In biên lai" OnClick="btnNBInBL_Click" />
                                    <asp:Button ID="btnInBL" runat="server" CssClass="button" Text="In biên lai" OnClick="btnInBL_Click" />
                                    <asp:Button ID="btnKyso" runat="server" CssClass="button" Text="In biên lai và ký số" OnClick="btnKyso_Click" Visible="false" />
                                    <asp:Button ID="cmdSave" runat="server" CssClass="button" Text="Lưu và ký số" OnClick="cmdSave_Click" />
                                    <asp:Button ID="btn_Gui" runat="server" CssClass="button" Text="Gửi" OnClick="btn_Gui_Click" />
                                    <asp:Button ID="btn_thuhoi" runat="server" CssClass="button" Text="Thu hồi" OnClick="btn_thuhoi_Click" />
                                    <a href="javascript:;" onclick="ClosePopup()" class="button">Đóng</a>
                                </div>
                                <div style="display: none;">
                                    <asp:Button ID="cmdSaveFileKyso" runat="server"
                                        CssClass="button" Text="Lưu file ký số"
                                        OnClick="cmdSaveFileKyso_Click" />
                                </div>
                                <div style="display: none;">
                                    <asp:Button ID="cmdCloseFileKyso" runat="server"
                                        CssClass="button" Text="Đóng file ký số"
                                        OnClick="cmdCloseFileKyso_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="Ajax_Manager_Updata">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
                //CheckKyso();
            }
            var count_file = 0;
           <%-- function CheckKyso() {
                var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');
                if (chkKySo.checked) {
                    document.getElementById("zonekyso").style.display = "";
                    document.getElementById("zonekythuong").style.display = "none";
                }
                else {
                    document.getElementById("zonekyso").style.display = "none";
                    document.getElementById("zonekythuong").style.display = "";
                }
            }--%>
            $(document).on('click', '.active-result', function (e) {
                javascript: setTimeout('__doPostBack(\'ctl00$dvSpliter$ContentPlaceHolder1$dgTructiep$ctl03$ddlQuocGiaUT\',\'\')', 0)
            })
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
                    var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                    var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');
                    var new_item = document.createElement("li");
                    new_item.innerHTML = received_msg.FileName;
                    hddFilePath.value = received_msg.FileServer;
                    //-------------Them icon xoa file------------------
                    var del_item = document.createElement("img");
                    del_item.src = '/UI/img/xoa.gif';
                    del_item.style.width = "15px";
                    del_item.style.margin = "5px 0 0 5px";
                    del_item.onclick = function () {
                        if (!confirm('Bạn muốn xóa file này?')) return false;
                        document.getElementById("file_name").removeChild(new_item);
                    }
                    del_item.style.cursor = 'pointer';
                    new_item.appendChild(del_item);

                    document.getElementById("file_name").appendChild(new_item);
                } else {
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
                //vgca_sign_file(json_prms, SignFileCallBack1);
                vgca_sign_approved(json_prms, SignFileCallBack1);
            }
            function RequestLicenseCallBack(rv) {
                var received_msg = JSON.parse(rv);
                if (received_msg.Status == 0) {
                    document.getElementById("_signature").value = received_msg.LicenseRequest;
                } else {
                    alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                }
            }

            function SignFileCallBack2(rv) {
                var received_msg = JSON.parse(rv);
                //alert("Trạng thái ký số:" + received_msg.Status + ":" + received_msg.Error);

                //console.log("Status:", received_msg.Status);
               <%--if (received_msg.Status != 0) {
                    //document.getelementbyid("_signature").value = received_msg.message;
                    alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                    $("#<%= cmdCloseFileKyso.ClientID %>").click();
                }--%>
              <%-- if (received_msg.Status == 14) {
                    $("#<%= cmdCloseFileKyso.ClientID %>").click();
                    //alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                }
                if (received_msg.Status == 501) {
                    $("#<%= cmdCloseFileKyso.ClientID %>").click();
                    //alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
                }--%>

                if (received_msg.Status == 0) {
                    var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');

                    var file_name = received_msg.FileName;
                    var file_path = received_msg.FileServer;
                    <%--var hdd_matb = document.getElementById('<%=hdd_matb.ClientID%>');
                    var hddDuongsu = document.getElementById('<%=hddDuongsu.ClientID%>');
                    var matbValue = hdd_matb.value;
                    var hddDuongsuValue = hddDuongsu.value;
                    var fileKysoValue = hddFileKySo.value;
                    var file_name = fileKysoValue + "/" + matbValue + "_" + hddDuongsuValue + ".pdf";
                    var file_path = hddFileKySo.value;
                    received_msg.FileName = file_name;
                    received_msg.FileServer = file_path;--%>

                    var new_item = document.createElement("li");

                    new_item.innerHTML = file_name;
                    hddFileKySo.value = file_path;

                    $("#<%= cmdSaveFileKyso.ClientID %>").click();
                    //alert("Đường dẫn ký số:" + hddFileKySo.value);
                } else {
                    //document.getElementById("_signature").value = received_msg.Message;
                    alert("Ký số không thành công.");
                    $("#<%= cmdCloseFileKyso.ClientID %>").click();
                }
            }

            var popupWindow;
            function exc_sign_approved() {
                var prms = {};
                var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
                var hddFileKySo = document.getElementById('<%=hddFileKySo.ClientID%>');
                var hdd_matb = document.getElementById('<%=hdd_matb.ClientID%>');
                var hddDuongsu = document.getElementById('<%=hddDuongsu.ClientID%>');
                prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
                prms["SessionId"] = "";//xác thực cookies
                prms["JWTToken"] = "";//xác thực jwt token
                // Truy xuất giá trị của hdd_matb và gán cho prms["FileName"] 
                if (hdd_matb) {
                    var matbValue = hdd_matb.value;
                    var fileKysoValue = hddFileKySo.value;
                    var hddDuongsuValue = hddDuongsu.value;
                    //prms["FileName"] = "http://localhost:8081/TempUpload/" + matbValue + "_" + hddDuongsuValue + ".pdf";
                    //prms["FileName"] = fileKysoValue + "/" + matbValue + "_" + hddDuongsuValue + ".pdf";
                    prms["FileName"] = fileKysoValue + "/" + matbValue + "_" + hddDuongsuValue + ".pdf";
                } else {
                    console.error('Không tìm thấy mã thông báo');
                }
                //prms["MetaData"] = scv;

                //alert('ký số:' + hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//'));
                var json_prms = JSON.stringify(prms);
                //alert('file name1:' + prms["FileName"]);
                //console.log('Tên file:', prms["FileName"]);
                console.log('file name:', json_prms);
                //prms["FileName"] = fileKysoValue + "/" + matbValue + "_" + hddDuongsuValue + ".pdf";
                //alert('file name2:' + json_prms);
                vgca_sign_approved(json_prms, SignFileCallBack2);

                // Đóng cửa sổ popup 
                if (popupWindow && !popupWindow.closed) {
                    popupWindow.close();
                    console.log("Cửa sổ popup đã được đóng!");
                }

            }

            let socket;
            let hasErrorOccurred = false;

            function checkUrlAndExecute() {
                // Reset error flag for each click
                hasErrorOccurred = false;
                const url = "wss://127.0.0.1:8987/SignApproved";
                // Close previous connection if it exists
                if (socket) {
                    socket.close();
                }

                socket = new WebSocket(url);

                socket.onopen = function () {
                    console.log("Kết nối thành công.");
                    //alert("Đã cài đặt công cụ ký số VGCA." + url);
                    exc_sign_approved();
                };

                socket.onerror = function (error) {
                    if (!hasErrorOccurred) {
                        hasErrorOccurred = true;
                        console.log("Lỗi kết nối:", error);
                        alert("Ký số không thành công. Bạn xem lại công cụ cài đặt/kết nối ký số VGCA.");
                        $("#<%= cmdCloseFileKyso.ClientID %>").click();
                    }
                };

                socket.onclose = function (event) {
                    if (event.wasClean) {
                        console.log("Kết nối được đóng");
                    } else {
                        console.log("Đóng kết nối lỗi.");
                    }
                };
            }

            function PopupReportSign(pageURL, title, w, h) {
                var left = (screen.width / 2) - (w / 2);
                var top = (screen.height / 2) - (h / 2);
                popupWindow = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);

                // Chờ cửa sổ mới tải xong rồi mới gọi hàm JavaScript tiếp theo 
                popupWindow.onload = function () {
                    console.log("Cửa sổ mới đã được tải xong!");
                    exc_sign_approved(); // Gọi hàm JavaScript tiếp theo 
                };
                return popupWindow;
            }

        </script>
        <script>
        <%-- function validate() {
                var txtSoBienLai = document.getElementById('<%=txtSoBienLai.ClientID%>');
                if (!Common_CheckTextBox(txtSoBienLai, "Số biên lai"))
                    return false;

                var txtTamUngAP = document.getElementById('<%=txtTamUngAP.ClientID%>');
                if (!Common_CheckTextBox(txtTamUngAP, "Tạm ứng án phí"))
                    return false;

                return true;
            }--%>

</script>
        <script type="text/javascript">
            function PopupReport(pageURL, title, w, h) {
                var left = (screen.width / 2) - (w / 2);
                var top = (screen.height / 2) - (h / 2);
                var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                return targetWin;
            }
        </script>
    </form>
</body>
</html>
<script src="UI/js/chosen.jquery.js"></script>
<script src="UI/js/init.js"></script>

<script>
    function ClosePopup() {
        var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
        var value = parseInt(hddIsReloadParent.value);
        if (value == 0)
            window.close();
        else {
            ReloadParent();
            window.close();
        }
    }
    function ReloadParent() {
        window.onunload = function (e) {
            alert('anhvhtest ReloadParent');
            opener.Loadds_tha();
        };
        //window.close();
    }       
</script>
