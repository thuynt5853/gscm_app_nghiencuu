<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pDKGiaoDichDienTu.aspx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Popup.pDKGiaoDichDienTu" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Personnal/UC/Help.ascx" TagPrefix="uc1" TagName="Help" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng ký nhận VB tống đạt</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />

    <link href="../../../../UI/css/Table.css" rel="stylesheet" />
    <link href="../../../../UI/css/Paging.css" rel="stylesheet" />

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
                    <style>
                        body {
                            width: 98%;
                            margin-left: 1%;
                            min-width: 0px;
                            overflow: auto;
                        }
                        .dropbox {
                            float: left;
                            margin-right: 5px;
                        }
                        .button_tracuu {
                            float: right;
                        }
                        .table1 tr, td {
                            padding-left: 0px;
                            padding-bottom: 8px;
                        }
                        input[type=checkbox] {
                            position: relative;
                            cursor: pointer;
                            margin-right: 9px;
                        }
                        input[type=checkbox]:before {
                            content: "";
                            display: block;
                            position: absolute;
                            width: 14px;
                            height: 14px;
                            top: 0;
                            left: 0;
                            border: 2px solid #555555;
                            border-radius: 3px;
                            background-color: white;
                        }
                        input[type=checkbox]:checked:after {
                            content: "";
                            display: block;
                            width: 5px;
                            height: 8px;
                            border: solid black;
                            border-width: 0 2px 2px 0;
                            -webkit-transform: rotate(45deg);
                            -ms-transform: rotate(45deg);
                            transform: rotate(45deg);
                            position: absolute;
                            top: 2px;
                            left: 6px;
                        }
                        .boxchungCK{
                            height: 150px;
                            overflow: auto;
                        }
                        .tableData tbody .header td{
                            color: black;
                        }
                        .tableData tbody .header{
                            height: 35px;
                        }
                    </style>
    
                    <asp:HiddenField ID="hddPageSize" runat="server" Value="10" />
                    <asp:HiddenField ID="hddID" runat="server" />
                    <asp:HiddenField ID="IDOLD" runat="server" />
                    <div class="thongtin_lienhe" style="margin-top: 0px;">
                        <div class="right_full_width_head">
                            <div class="dangky_head_title">Đăng ký nhận văn bản, thông báo của Tòa án</div>
                        </div>

                        <div class="dangky_content">
                            <div id="dangkynhanvb_tongdat">
                                <div class="right_full_width head_title_center">
                                    <span>Cộng hòa xã hội chủ nghĩa Việt nam</span>
                                </div>
                                <div class="right_full_width head_title_center" style="margin-bottom: 15px;">
                                    <span style="text-transform: none;">Độc lập - Tự do - Hạnh phúc</span>
                                    <span style="border-bottom: solid 1px gray; width: 24%; float: left; margin-left: 38%; margin-top: 5px;"></span>
                                </div>
                                <div class="right_full_width head_title_center">
                                    <span style="font-size: 15pt;">Đăng ký nhận văn bản, thông báo của Tòa án</span>
                                </div>
                                <div id="zone_message"></div>
                                <div class="dk_fullwidth">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 120px;">
                                                <div style="float: right; font-weight: bold; margin-right: 5px;">Kính gửi<span class="batbuoc">*</span> </div>
                                            </td>
                                            <td>
                                                <asp:HiddenField ID="hddToaAnID" runat="server" />
                                                <asp:TextBox ID="txtToaAn" CssClass="dangky_tk_textbox"
                                                    runat="server" Width="75%"
                                                    placeholder="(Gõ tên Tòa án vào đây để tìm kiếm và lựa chọn Tòa án để nhận đăng ký)"
                                                    MaxLength="250" AutoCompleteType="Search"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div class="boxchung">
                                                    <h4 class="tleboxchung">Thông tin người đăng ký nhận văn bản, thông báo mới</h4>
                                                    <div class="boder" style="padding: 20px 10px;">
                                                        <table style="width: 100%">
                                                            <tr>
                                                                <td style="width: 130px;" class="cell_label">Tên tôi là:</td>
                                                                <td colspan="3">
                                                                    <asp:Literal ID="lttDuongSu" runat="server"></asp:Literal>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="cell_label">Số CMND:</td>
                                                                <td style="width: 250px;">
                                                                    <asp:Literal ID="lttCMND" runat="server"></asp:Literal></td>
                                                                <td style="width: 65px;" class="cell_label">Quốc tịch:</td>
                                                                <td>
                                                                    <asp:Literal ID="lttQuocTich" runat="server"></asp:Literal>
                                                                </td>
                                                            </tr>
                                                            <asp:Literal ID="lttEmail" runat="server"></asp:Literal>
                                                            <asp:Literal ID="lttDiachi" runat="server"></asp:Literal>
                                                        </table>
                                                    </div>
                                                </div>

                                                <div class="boxchungCK">
                                                    <h4 class="tleboxchung">CAM KẾT CỦA NGƯỜI KHỞI KIỆN, NGƯỜI THAM GIA TỐ TỤNG KHI ĐĂNG KÝ GIAO DỊCH ĐIỆN TỬ VỚI TÒA ÁN</h4>
                                                    <div class="boder" style="padding: 20px 10px;">
                                                        <p>- Đồng ý nhận các văn bản tống đạt của Tòa án qua tài khoản giao dịch điện tử của Người khởi kiện, người tham gia tố tụng trên dịch vụ công “gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng” (https://nopdonkhoikien.toaan.gov.vn/) và xác nhận tuân theo các quy định trong giao dịch điện tử, và các quy định sau:</p>
                                                        <p>&emsp;&ensp;• Ngày gửi thông điệp dữ liệu điện tử của người khởi kiện, người tham gia tố tụng được xác định là ngày Dịch vụ công “gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng” của Tòa án xác nhận đã nhận được thông điệp dữ liệu điện tử do người khởi kiện, người tham gia tố tụng gửi đến;</p>
                                                        <p>&emsp;&ensp;• Ngày nhận các văn bản tống đạt của người khởi kiện, người tham gia tố tụng được tính từ ngày Dịch vụ công của Tòa án gửi văn bản tống đạt đến tài khoản giao dịch điện tử của Người khởi kiện, người tham gia tố tụng trên hệ thống Dịch vụ công “gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng” (https://nopdonkhoikien.toaan.gov.vn/) .</p>
                                                        <p>- Người khởi kiện, người tham gia tố tụng chịu trách nhiệm với việc thường xuyên kiểm tra tài khoản giao dịch điện tử để tra cứu, xem, in, sử dụng thông điệp dữ liêụ điện tử đã gửi, nhận khi tài khoản còn hiệu lực, có trách nhiệm tiếp nhận, thực hiện các nội dung, yêu cầu ghi trên văn bản tố tụng của Tòa án trong thời hạn quy định và tự chịu trách nhiệm trong trường hợp không thực hiện việc đăng nhập, tiếp nhận, thực hiện các nội dung, yêu cầu trên văn bản tố tụng của Tòa án.</p>
                                                        <p>- Cam kết thực hiện đúng các quy định tại Nghị quyết số 04 /2016/NQ-HĐTP ngày 30 tháng 12 năm 2016 của Hội đồng thẩm phán Tòa án nhân dân tối cao,  các quy định của Bộ luật tố tụng dân sự, Luật tố tụng hành chính và các quy định pháp luật liên quan.</p>
                                                        <p>- Cam kết sẽ chịu hoàn toàn trách nhiệm về việc bảo quản thông tin tài khoản giao dịch điện tử với Tòa án, và sẽ chịu trách nhiệm pháp lý nếu làm lộ, lọt thông tin dữ liệu trong quá trình giao dịch điện tử với Tòa án.</p>
                                                        <br />
                                                        <asp:CheckBox ID="chkConfirm" runat="server" Font-Bold="true" Text="Tôi đã đọc và đồng ý với các quy định giao dịch điện tử" />
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <br />
                                                <asp:CheckBox ID="chkChonVuViec" runat="server" Font-Bold="true" Text="Chọn vụ việc" AutoPostBack="true" OnCheckedChanged="chkChonVuViec_CheckedChanged"/>
                                                <br />
                                                <br />
                                                <asp:Panel ID="pnDSVuViec" runat="server" Visible="false">
                                                    <div class="boxchung">
                                                        <h4 class="tleboxchung">Lựa chọn vụ việc</h4>
                                                        <div class="boder" style="padding: 20px 10px;">
                                                            <asp:HiddenField ID="hddBatBuocNhapBAST" runat="server" Value="0" />
                                                            <table style="width: 100%">
                                                                <tr>
                                                                    <td colspan="4"><b>Ghi chú:</b>
                                                                        <i>
                                                                            <ul class="ds_tailieu_denghi">
                                                                                <li>Bấm chọn mục "Tư cách tố tụng" để tìm kiếm các vụ việc tương ứng
                                                                                </li>
                                                                                <li>Tích chọn các vụ việc yêu cầu gửi văn bản, thông báo mới 
                                                                                        trong danh sách vụ việc hiển thị
                                                                                </li>
                                                                                <asp:Literal ID="lttGhichu" runat="server"></asp:Literal>
                                                                            </ul>
                                                                        </i>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width: 130px;" class="cell_label">Tư cách tố tụng</td>
                                                                    <td style="width: 220px;">
                                                                        <asp:DropDownList ID="ddlTucachTotung" CssClass="dropbox" runat="server"
                                                                            placeholder="---Chọn-----" Width="200px">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td class="cell_label" style="width: 80px;">Cấp xét xử</td>
                                                                    <td>
                                                                        <asp:DropDownList ID="dropCapXetXu" CssClass="dropbox"
                                                                            runat="server" placeholder="---Chọn-----" Width="200px">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="cell_label">Số thụ lý <asp:Literal ID="ltSoThuLy" runat="server"></asp:Literal></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtSothuly" CssClass="textbox" runat="server"
                                                                            Width="186px"></asp:TextBox>
                                                                    </td>
                                                                    <td class="cell_label">Ngày thụ lý <asp:Literal ID="ltNgayThuLy" runat="server"></asp:Literal></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="textbox" Width="186px" MaxLength="10"></asp:TextBox>
                                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td></td>
                                                                    <td><asp:CheckBox ID="chkBoxThuLy"  runat="server" Text="Chưa thụ lý" OnCheckedChanged="chkLinked_CheckedChanged" AutoPostBack="true" />
                                                                    </td><td colspan="1">
                                                                        <asp:ImageButton runat="server" ImageUrl="/UI/img/tracuu.png"
                                                                            OnClientClick="return validate_toaan();"
                                                                            ID="ImageButton1" OnClick="cmdTraCuu_Click"
                                                                            CssClass="button_tracuu" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4" style="font-weight: bold; text-transform: uppercase;">Danh sách vụ việc</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4">
                                                                        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                                                        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

                                                                        <asp:Panel runat="server" ID="pnPagingTop" Visible="false">
                                                                            <div class="phantrang" style="float: left; width: 96%;">
                                                                                <div class="sobanghi">
                                                                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                                                                </div>
                                                                                <div class="sotrang">
                                                                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                                                        OnClick="lbTBack_Click"><</asp:LinkButton>
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
                                                                                        OnClick="lbTNext_Click">></asp:LinkButton>
                                                                                </div>
                                                                            </div>
                                                                        </asp:Panel>
                                                                        <div class="CSSTableGenerator" id="IdTableGenerator" style="width: 96%;">
                                                                            <table>
                                                                                <tr id="row_header">
                                                                                    <td style="width: 40px;">Chọn</td>
                                                                                    <td style="width: 134px;">Thông tin thụ lý</td>
                                                                                    <td>Thông tin vụ việc</td>
                                                                                    <td style="width: 100px;">Loại vụ việc</td>
                                                                                    <td style="width: 100px;">Tư cách tố tụng</td>
                                                                                </tr>
                                                                                <asp:Repeater ID="rpt" runat="server"
                                                                                    OnItemCommand="rpt_ItemCommand"
                                                                                    OnItemDataBound="rpt_ItemDataBound">
                                                                                    <ItemTemplate>
                                                                                        <tr class="trItem">
                                                                                            <td>
                                                                                                <asp:Panel ID="pnItem" runat="server" />
                                                                                                <asp:HiddenField ID="hddVuAnID" Value='<%#Eval("VuAnID") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddQLAn_DuongSuID" Value='<%#Eval("ID") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddMaLoaiVuViec" Value='<%#Eval("MaLoaiVuAn") %>' runat="server" />
                                                                                                <%--<asp:HiddenField ID="hddTenVuViec" Value='<%#Eval("TenVuViec") %>' runat="server" />--%>
                                                                                                <asp:HiddenField ID="hddMaVuViec" Value='<%#Eval("MaVuViec") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddMaGiaiDoan" Value='<%#Eval("MaGiaiDoan") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddToaSoTham" Value='<%#Eval("ToaAnID") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddToaPhucTham" Value='<%#Eval("ToaPhucThamID") %>' runat="server" />
                                                                                                <asp:HiddenField ID="hddMaTuCachTT" Value='<%#Eval("TuCachToTung_Ma") %>' runat="server" />
                                                                                                <div style="text-align: center;">
                                                                                                    <asp:CheckBox ID="chk" runat="server" />
                                                                                                </div>
                                                                                            </td>
                                                                                            <td><%#Eval("THONGTINTHULY") %></td>
                                                                                            <td><%#Eval("TenVuViec") %></td>
                                                                                            <td><%#Eval("LoaiVuAn") %></td>
                                                                                            <td><%#Eval("TuCachToTung") %></td>
                                                                                        </tr>
                                                                                    </ItemTemplate>
                                                                                </asp:Repeater>
                                                                            </table>
                                                                        </div>
                                                                        <asp:Panel runat="server" ID="pnPagingBottom" Visible="false">
                                                                            <div class="phantrang" style="width: 96%;">
                                                                                <div class="sobanghi">
                                                                                    <asp:HiddenField ID="hdicha" runat="server" />
                                                                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                                                                </div>
                                                                                <div class="sotrang">
                                                                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                                                        OnClick="lbTBack_Click"><</asp:LinkButton>
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
                                                                                        OnClick="lbTNext_Click">></asp:LinkButton>
                                                                                </div>
                                                                            </div>
                                                                        </asp:Panel>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><b style="margin-top: 10px; float: left;">Yêu cầu Tòa án gửi văn bản, thông báo mới của vụ việc cho tôi!</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"> 
                                                <div class="msg_warning">Các vụ việc đã được đăng ký nhận VB tống đạt và có tình trạng là đang giao dịch sẽ không được đăng ký lại!</div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="fullwidth" style="text-align: center; margin-top: 15px; margin-bottom: 5px;">
                                    <div class="msg_thongbao">
                                        <asp:Literal ID="lttThongBao" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <div class="fullwidth" style="text-align: center; margin-top: 15px; margin-bottom: 5px;">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="button_checkchkso"
                                        Text="Đăng ký nhận văn bản" OnClick="cmdUpdate_Click" OnClientClick="return validate_toaan();" />
                                    <input type="button" class="buttoninput quaylai" onclick="ReloadParent();" value="Quay lại"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="display: none;">
                    <asp:ImageButton runat="server" ImageUrl="/UI/img/tracuu.png"
                        ID="cmdSetCapXetXu" OnClick="cmdSetCapXetXu_Click"
                        CssClass="button_tracuu" />
                </div>

                <script>                    
                    function ReloadParent(){
                        window.close();
                    }
                    function validate_toaan() {
                        var zone_message = document.getElementById('zone_message');
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
                        }
                        zone_message.style.display = "none";
                        return true;
                    }
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
                    $(document).on('click', '.trItem', function () {
                        let thongbao = $(this).children(":first").children(":first").attr('thongbao');
                        if (thongbao != undefined) {
                            alert(thongbao);
                        }
                    })
                    function pageLoad(sender, args) {
                        $(function () {
                            var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetAllToaTraVBTongDatOnline") %>';
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
                    function Load_data_theodk() {
                        if (!validate_toaan())
                            return false;
                        $("#<%= cmdSetCapXetXu.ClientID %>").click();
                    }
                    $(document).ready(function () {
                        $('input[type=text]').on('keypress', function (e) {
                            if (e.which == 13)
                                $("#<%= cmdSetCapXetXu.ClientID %>").click();
                        });
                    });
                </script>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>

</html>
