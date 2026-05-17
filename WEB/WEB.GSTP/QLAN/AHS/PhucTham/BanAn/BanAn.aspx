<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="BanAn.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.BanAn.BanAn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddShowBA" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanPhanCong" Value="" runat="server" />
    <asp:HiddenField ID="hddThoiHanThang" Value="0" runat="server" />
    <asp:HiddenField ID="hddThoiHanNgay" Value="0" runat="server" />
    <asp:HiddenField ID="ttBanDauDONKK_USER_DKNHANVB" runat="server" Value="0" />
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <asp:HiddenField ID="hddIsSuaDoi" Value="1" runat="server" />
    <style>
        .align_right {
            text-align: right;
        }

        .phantrang_bottom {
            display: block;
            line-height: 20px;
            margin-bottom: 2px;
            margin-top: 5px;
            overflow: hidden;
            width: 100%;
        }

        .tleboxchung {
            text-transform: uppercase;
        }

        .col1 {
            width: 130px;
        }

        .col2 {
            width: 230px;
        }

        .col3 {
            width: 100px;
        }

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 145px;
        }

        .QDVACol1 {
            width: 107px;
        }

        .QDVACol2 {
            width: 270px;
        }

        .QDVACol3 {
            width: 116px;
        }
    </style>
    <asp:Panel ID="pnBAPT" runat="server" ClientIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
                        <div class="boder" style="padding: 10px;">
                            <div>
                                <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" Visible="false" />
                                <asp:TextBox ID="txtToaAn" CssClass="user" runat="server"
                                    Width="200px" Visible="false"></asp:TextBox>
                            </div>
                            <table class="table1">
                                <tr>
                                    <td colspan="4">
                                        <asp:RadioButtonList ID="rdbPanelBA" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelBA_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 125px;">Ngày mở phiên tòa<span class="batbuoc">(*)</span></td>
                                    <td style="width: 120px;">
                                        <asp:TextBox ID="txtNgayMoPhienToa" AutoPostBack="true" OnTextChanged="txtNgaymophientoa_TextChanged"
                                            runat="server" CssClass="user" Width="100px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayMoPhienToa"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayMoPhienToa"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 70px;">Địa điểm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtDiaDiem" CssClass="user" runat="server" Width="470px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số bản án<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSoBanAn" CssClass="user align_right"
                                            runat="server" Width="100px" onkeypress="return isNumber(event)"></asp:TextBox>
                                    </td>
                                    <td>Ngày<span class="batbuoc">(*)</span></td>
                                    <td style="width: 120px;">
                                        <asp:TextBox ID="txtNgayBanAn" runat="server" CssClass="user"
                                            Width="100px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBanAn"
                                            Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBanAn"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                    <td style="width: 94px;">Người ký<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:HiddenField ID="hddNguoiKyID" runat="server" />
                                        <asp:TextBox ID="txtNguoiKy" CssClass="user" Enabled="false"
                                            runat="server" Width="242px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Kết quả phúc thẩm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlKetQuaPhucTham" CssClass="chosen-select"
                                            runat="server" Width="312px" AutoPostBack="true" OnSelectedIndexChanged="ddlKetQuaPhucTham_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>Nguyên nhân<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:DropDownList ID="ddlLyDoBanAn" CssClass="chosen-select"
                                            runat="server" Width="250px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 80px">Tội danh chính của vụ án<span class="batbuoc">(*)</span>
                                    </td>
                                    <td style="width: 125px">
                                        <asp:DropDownList ID="ddlToiDanhVuAn" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Có công bố bản án ?<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdCongboBA" AutoPostBack="true"
                                            runat="server" RepeatDirection="Horizontal"
                                            OnSelectedIndexChanged="rdCongboBA_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <asp:Panel ID="pnZonekythuong" runat="server">
                                        <td>Đính kèm tệp</td>
                                        <td colspan="5">
                                            <asp:HiddenField ID="hddFilePath" runat="server" />
                                            <%--<div style="display: none;">--%>
                                            <%--<asp:CheckBox ID="chkKySo" Checked="false" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" /></div>--%>
                                            <br />
                                            <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                            <asp:HiddenField ID="hddSessionID" runat="server" />
                                            <asp:HiddenField ID="hddURLKS" runat="server" />
                                            <%--                                    <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px;display:none;">
                                        <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                        <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình</button><br />
                                        <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                        </ul>
                                    </div>--%>
                                            <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                                <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                                <asp:Image ID="Throbber" runat="server"
                                                    ImageUrl="~/UI/img/loading-gear.gif" />
                                            </div>
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td colspan="5">
                                        <div style="float: left;">
                                            <div style="float: left;">
                                                <asp:LinkButton ID="lbtDownload" Visible="false"
                                                    runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                                            </div>
                                            <div style="float: left; margin-left: 15px; font-weight: bold;">
                                                <asp:ImageButton Visible="false" ID="lbtXoaFile" runat="server" ToolTip="Xóa"
                                                    ImageUrl="/UI/img/xoa.gif" Width="17px" OnClick="lbtXoaFile_Click"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                            </div>
                                            <div style="float: left; width: 100%; color: red">
                                                <asp:Literal ID="MSG_file" runat="server" Text=""></asp:Literal>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="lttMsgBanAn" runat="server"></asp:Literal>
                                        </div>
                                        <div style="margin: 5px 0; text-align: center; width: 100%; float: left;">
                                            <asp:Button ID="cmdUpdateBanAnST" runat="server" CssClass="buttoninput"
                                                Text="Lưu bản án phúc thẩm" OnClick="cmdUpdateBanAnST_Click" OnClientClick="return validate();" />
                                            <asp:Button ID="cmdHuyBanAn" runat="server" CssClass="buttoninput"
                                                Text="Xóa bản án" OnClick="cmdHuyBanAn_Click"
                                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản án này? ');" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Panel ID="pnAnPhi" runat="server">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Quyết định & điều luật</h4>
                            <div class="boder" style="padding: 10px;">

                                <div class="zone_ghichu" style="display: none;">
                                    <b>Ghi chú</b><br />
                                    <b>1. Lưu án phí cho bị cáo</b><br />
                                    1.1. Nhập mức án phí cho bị cáo<br />
                                    1.2. Ấn chọn "Lưu" để cập nhật thông tin<br />
                                    <b>2. Cập nhật quyết định & điều luật áp dụng cho bị cáo</b><br />
                                    2.1. Chọn bị cáo
                            <br />
                                    2.2. Chọn "Điều luật áp dụng" của bị cáo được chọn<br />
                                </div>
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lttMsgAnPhi" runat="server"></asp:Literal>
                                </div>
                                <div style="">

                                    <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rpt_ItemDataBound">
                                        <HeaderTemplate>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="20px">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Bị cáo - Tội danh</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Quyết định sơ thẩm</strong></div>
                                                    </td>
                                                    <td width="130px">
                                                        <div align="center"><strong>Yêu cầu kháng cáo/ kháng nghị</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Quyết định phúc thẩm</strong></div>
                                                    </td>
                                                    <td width="110px">
                                                        <div align="center"><strong>Tham gia phiên tòa</strong></div>
                                                    </td>
                                                    <td width="30px">
                                                        <div align="center"><strong>Án phí (Đơn vị là đồng)</strong></div>
                                                    </td>
                                                    <td width="110px">
                                                        <div align="center"><strong>Ngày nhận bản án</strong></div>
                                                    </td>
                                                    <td width="130px">
                                                        <div align="center"><strong>Điều luật áp dụng</strong></div>
                                                    </td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="hddBiCao" runat="server" Value='<%#Eval("BiCanID") %>' />
                                                    <%# Eval("STT") %></td>
                                                <td><%#Eval("HoTen") %> - <%#Eval("getalltoidanh") %></td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lblTHtoidanh" runat="server" Text=""></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lbNoiDung_KCKN" runat="server" Text=""> <%#Eval("NoiDung_KCKN") %></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Label ID="lblTHtoidanhPT" runat="server" Text=""></asp:Label>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center;">
                                                        <asp:CheckBox ID="chkThamGiaPhienToa" runat="server"
                                                            Checked='<%# (Convert.ToInt16(Eval("IsThamGiaPhienToa"))>0)? true:false %>' />
                                                    </div>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAnPhi" runat="server" Text='<%#Eval("AnPhi") %>' onkeypress="return isNumber(event)" CssClass="user align_right"></asp:TextBox></div>
                                                </td>
                                                <td>
                                                    <div style="text-align: center;">
                                                        <asp:TextBox ID="txtNgaynhanbanan" runat="server" Text='<%# string.Format("{0:dd/MM/yyyy}",Eval("NgayNhanBanAn")) %>' CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgaynhanbanan_CalendarExtender" runat="server" TargetControlID="txtNgaynhanbanan" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgaynhanbanan_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhanbanan" Mask="99/99/9999"
                                                            MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True"
                                                            Century="2000" CultureAMPMPlaceholder=""
                                                            CultureCurrencySymbolPlaceholder="₫"
                                                            CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div align="center">
                                                        <asp:Panel ID="lnLinkToiDanh" runat="server">
                                                            <%--GTEL-DUCPH 29-09-2025 thêm hidden field để check bị can đã đồng bộ hay chưa thì không cho popup--%>
                                                            <asp:HiddenField ID="hddDaDongBo" runat="server" Value="0" />
                                                            <a href="javascript:;" onclick="popupChonToiDanh(<%#Eval("BiCanID") %>,'<%# ((HiddenField)Container.FindControl("hddDaDongBo")).ClientID %>')" class="link_ds">Điều luật áp dụng</a>
                                                            <%--<a href="javascript:;" class="link_ds"
                                                                onclick="popupChonToiDanh(<%#Eval("BiCanID") %>)">Điều luật áp dụng</a>--%>
                                                        </asp:Panel>
                                                    </div>
                                                </td>
                                                <td style="display: none;">
                                                    <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>

                                    <div class="phantrang_bottom">
                                        <div class="sobanghi">
                                            <asp:Button ID="cmdSave2" runat="server" CssClass="buttoninput"
                                                Text="Lưu án phí" OnClick="cmdSave_Click" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <div class="boxchung">
                        <h4 class="tleboxchung">Các chỉ tiêu hỗ trợ thống kê</h4>
                        <asp:HiddenField ID="hddTotalCaNhan" runat="server" Value="0" />
                        <asp:HiddenField ID="hddTotalPhapNhan" runat="server" Value="0" />
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td style="width: 280px;">
                                        <div style="float: left; line-height: 28px;">Có áp dụng Án lệ<span class="batbuoc">(*)</span></div>
                                        <asp:DropDownList runat="server" ID="ddlCBBA_Anle" Style="float: right;" CssClass="user"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 280px;">
                                        <div style="float: left; line-height: 28px;">Án rút gọn<span class="batbuoc">(*)</span></div>
                                        <asp:RadioButtonList ID="rdAnRutGon" runat="server" Style="float: right;" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 280px;">
                                        <div style="float: left; line-height: 28px;">Bạo lực gia đình<span class="batbuoc">(*)</span></div>
                                        <asp:RadioButtonList ID="rdBaoLucGD" runat="server" Style="float: right;" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 280px;">
                                        <div style="float: left; line-height: 28px;">Xét xử lưu động<span class="batbuoc">(*)</span></div>
                                        <asp:RadioButtonList ID="rdXetXuLuuDong" runat="server" Style="float: right;" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <!------------------------------------------------->
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Sửa phần hình phạt bổ sung hoặc áp dụng các biện pháp tư pháp<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdSuaHinhPhatBS" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdSuaHinhPhatBS_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <asp:Panel ID="txtSuaHinhPhatBS" runat="server" Visible="false">
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaHinhPhatBS_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaHinhPhatBS_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>

                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdSuaBoiThuongTH" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdSuaBoiThuongTH_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <asp:Panel ID="txtSuaBoiThuongTH" runat="server" Visible="false">
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaBoiThuongTH_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaBoiThuongTH_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>

                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Sửa các phần khác<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdSuaKhac" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdSuaKhac_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <asp:Panel ID="txtSuaKhac" runat="server" Visible="false">
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaKhac_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>

                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaKhac_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Sửa quyết định của bản án sơ thẩm đối với bị cáo không có kháng cáo, kháng nghị<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdSuaQDAnSoTham" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdSuaQDAnSoTham_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <asp:Panel ID="txtSuaQDAnSoTham" runat="server" Visible="false">
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaQDAnSoTham_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox>
                                        </td>
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtSuaQDAnSoTham_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Vi phạm hạn tạm giam trong giai đoạn xét xử<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdViPhamHan" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdViPhamHan_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <asp:Panel ID="txtViPhamHan" runat="server" Visible="false">
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtViPhamHan_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox>
                                        </td>
                                        <td>
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtViPhamHan_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox>
                                        </td>
                                    </asp:Panel>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Khởi tố vụ án tại phiên tòa<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdKhoiToTaiToa" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td>Số vụ án VKS rút kháng nghị, người có kháng cáo không rút kháng cáo<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdKoRutKhangCao" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Tòa án chấp nhận kháng nghị của VKS<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:RadioButtonList ID="rdDuyetKhangNghiVKS" runat="server" RepeatDirection="Horizontal"
                                            AutoPostBack="true" OnSelectedIndexChanged="rdDuyetKhangNghiVKS_SelectedIndexChanged">
                                            <asp:ListItem Value="0">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>

                                    <asp:Panel ID="txtDuyetKN_VKS" runat="server" Visible="false">
                                        <td colspan="1">
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là cá nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtDuyetKN_VKS_BiCao" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCCaNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>
                                        <td colspan="2">
                                            <div style="float: left; width: 150px; line-height: 22px;">Số bị cáo là pháp nhân<span class="batbuoc">(*)</span></div>
                                            <asp:TextBox ID="txtDuyetKN_VKS_PhapNhan" runat="server"
                                                onkeypress="return isNumber(event)" onblur="validSoBCPhapNhan(this)" CssClass="user align_right" MaxLength="3"
                                                Width="100px"></asp:TextBox></td>
                                    </asp:Panel>

                                </tr>
                                <!------------------------------------------------->
                                <tr>
                                    <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                                </tr>
                                <tr>
                                    <td>Số bị cáo TA giữ nguyên án sơ thẩm, không chấp nhận K.N của VKS<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSBC_GIUNGUYEN_AN_ST" runat="server" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            Width="210px" MaxLength="10"></asp:TextBox>
                                    </td>

                                    <td>Số bị cáo TA sửa án sơ thẩm, không theo hướng K.N của VKS<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSBC_SUA_AN_ST" runat="server" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            Width="210px" MaxLength="10"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số bị cáo TA chấp nhận toàn bộ K.N của VKS<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSBC_CHAPNHAN_TOANBO" runat="server" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            Width="210px" MaxLength="10"></asp:TextBox>
                                    </td>
                                    <td>Số bị cáo TA chấp nhận một phần K.N của VKS<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtSBC_CHAPNHAN_MOTPHAN" runat="server" CssClass="user align_right" onkeypress="return isNumber(event)"
                                            Width="210px" MaxLength="10"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                            <asp:Literal ID="lttMsgThongKe" runat="server"></asp:Literal>
                                        </div>
                                        <div style="margin: 5px 0; text-align: center; width: 100%; float: left;">
                                            <asp:Button ID="cmdSaveThongKe" runat="server" CssClass="buttoninput"
                                                Text="Lưu thông tin hỗ trợ thống kê"
                                                OnClick="cmdSaveThongKe_Click" OnClientClick="return validate_chitieu_tk();" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <asp:Button ID="cmdReloadParent" runat="server" CssClass="buttoninput" Style="display: none" OnClick="cmdReloadParent_Click" />
                    </div>
                    <div class="boxchung">
                    </div>


                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnQDVV" runat="server" Visible="false" ChildrenAsTriggers="true" ClienIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">THÔNG TIN BA/QĐ</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td colspan="4">
                                    <asp:RadioButtonList ID="rdbPanelQD" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="true" OnSelectedIndexChanged="rdbPanelQD_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Bản án" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td>Tên quyết định<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:DropDownList ID="ddlQuyetdinh" CssClass="chosen-select" runat="server" Width="650px"
                                        AutoPostBack="True" ClientIDMode="AutoID" OnSelectedIndexChanged="ddlQuyetdinh_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td class="QDVACol1">Ngày mở phiên tòa</td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="TextBox1" runat="server" CssClass="user"
                                        Width="100px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayMoPhienToa"
                                        Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td class="QDVACol3">Địa điểm</td>
                                <td colspan="3">
                                    <asp:TextBox ID="TextBox2" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>

                            <asp:Panel ID="pnKetquaPhuctham" runat="server" Visible="false">
                                <tr>
                                    <td>Kết quả phúc thẩm<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlKetquaQuyetdinh" CssClass="chosen-select" runat="server" Width="450px" AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaQuyetdinh_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pnLyDoKetquaPhuctham" runat="server" Visible="false">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydoQuyetdinh" CssClass="chosen-select" runat="server" Width="450px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>

                            <asp:Panel ID="pnHinhThucXetXu" runat="server" Visible="false">
                                <tr>
                                    <td>Hình thức xét xử</td>
                                    <td>
                                        <asp:DropDownList ID="ddlHTXX" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true">
                                            <asp:ListItem Text="-Chọn-" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Xử kín trực tuyến" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Xử kín trực tiếp" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Xử công khai trực tuyến" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="Xử công khai trực tiếp" Value="4"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>


                            <asp:Panel ID="pnLyDo" runat="server">
                                <tr>
                                    <td>Lý do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlLydo" CssClass="chosen-select" runat="server" Width="650px"></asp:DropDownList>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <asp:Panel ID="pntxtLydo" runat="server">
                                <tr>
                                    <td id="lbtxtLydo" runat="server"></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtLydo" CssClass="user" placeholder="" runat="server" Width="640px" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:Panel>
                            <tr>
                                <td>Có công bố quyết định?<span class="batbuoc">(*)</span></td>
                                <td colspan="3">
                                    <asp:RadioButtonList ID="rdCongBoQD" AutoPostBack="true"
                                        runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0" Text="Không"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Có"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <asp:PlaceHolder ID="phNguoiKyDdl" runat="server" Visible="false">
                                <tr>
                                    <td>Người ký<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                    </td>

                                </tr>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="phNguoiKyTxt" runat="server" Visible="true">
                                <tr>
                                    <td>Người ký</td>
                                    <td>
                                        <asp:TextBox ID="txtNguoiKyQDVV" CssClass="user" Enabled="false" runat="server"
                                            Width="242px" MaxLength="250"></asp:TextBox></td>
                                    <td>Chức vụ/Chức danh</td>
                                    <td>
                                        <asp:TextBox ID="txtChucvu" CssClass="user" Enabled="false" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                </tr>
                            </asp:PlaceHolder>

                            <tr>
                                <td class="QDVACol1">Số Quyết định<span class="batbuoc">(*)</span></td>
                                <td class="QDVACol2">
                                    <asp:TextBox ID="txtSoQD" runat="server" CssClass="user align_right"
                                        Width="242px" MaxLength="50"></asp:TextBox>
                                </td>
                                <td class="QDVACol3">Ngày quyết định <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Hiệu lực từ ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieulucTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtHieulucTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtHieulucTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Hiệu lực đến ngày</td>
                                <td>
                                    <asp:TextBox ID="txtHieuLucDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtHieuLucDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtHieuLucDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Tệp đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePathQD" runat="server" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoadQD" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedCompleteQD"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <%--<asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />--%>
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm tệp đính kèm"></asp:LinkButton>
                                </td>
                            </tr>
                            <%--<tr>
                            <td>File đính kèm</td>
                            <td colspan="3">
                                <asp:HiddenField ID="HiddenField1" runat="server" />
                                <asp:CheckBox ID="chkKySo" Visible="false" Checked="true" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                <br />
                                <asp:HiddenField ID="HiddenField2" runat="server" Value="" />
                                <asp:HiddenField ID="HiddenField3" runat="server" />
                                <asp:HiddenField ID="HiddenField4" runat="server" />
                                <div id="zonekyso" style="display: none; margin-bottom: 5px; margin-top: 10px;">
                                    <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                    <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CSK</button><br />
                                    <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                    </ul>
                                </div>
                                <div id="zonekythuong" style="margin-top: 10px; width: 80%;">
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad1" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                                    <asp:Image ID="Image1" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                </div>
                            </td>
                        </tr>--%>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <asp:LinkButton ID="LinkButton1" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <asp:Button ID="btnUpdate" runat="server" CssClass="buttoninput"
                                    Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Label ID="lbThongBaoQD" runat="server" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div>
                                    <asp:HiddenField ID="hddidQD" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyTxtID" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyQDID" runat="server" Value="0" />
                                    <%--                                    <asp:Label runat="server" ID="lbThongBaoQD" ForeColor="Red"></asp:Label>--%>
                                </div>
                                <asp:Panel runat="server" ID="pndataQD" Visible="false">

                                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                        PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                        ItemStyle-CssClass="chan" Width="100%"
                                        OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                        <Columns>
                                            <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    TT
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%# Container.DataSetIndex + 1 %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Tên Quyết định
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <%#Eval("TenQD") %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SOQUYETDINH" HeaderText="Số QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày ra QĐ" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NguoiKy" HeaderText="Người ký" HeaderStyle-Width="95px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="TENTOAAN" HeaderText="Tòa án ra QĐ" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                            <%--<asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                    <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>' CausesValidation="false" CommandName="Download"
                                            CommandArgument='<%#Eval("FILEID") %>' CssClass="TenFile_css"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateColumn>--%>
                                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                                <HeaderTemplate>Tệp đính kèm</HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="DownloadQD"
                                                        CommandArgument='<%#Eval("FILEID") %>' ToolTip='<%#Eval("TENFILE")%>' UseSubmitBehavior="False" />
                                                    <%--<asp:LinkButton ID="lblDownload" runat="server" Text='<%#Eval("TENFILE") %>'  CssClass="TenFile_css"></asp:LinkButton>--%>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    Thao tác
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                    &nbsp;&nbsp;
                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle CssClass="header"></HeaderStyle>
                                        <ItemStyle CssClass="chan"></ItemStyle>
                                        <PagerStyle Visible="false"></PagerStyle>
                                    </asp:DataGrid>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script>

        function validSoBCCaNhan(input) {
            var hddMaxSBC_CaNhan = document.getElementById('<%=hddTotalCaNhan.ClientID%>');
            if (parseInt(input.value, 10) > parseInt(hddMaxSBC_CaNhan.value, 10)) {
                alert('Mục "Số bị cáo là cá nhân" vượt quá số lượng bị cáo. Hãy kiểm tra lại!');
                input.value = '0';
                input.focus();
            }
        }

        function validSoBCPhapNhan(input) {
            var hddMaxSBC_PhapNhan = document.getElementById('<%=hddTotalPhapNhan.ClientID%>');
            if (parseInt(input.value, 10) > parseInt(hddMaxSBC_PhapNhan.value, 10)) {
                alert('Mục "Số bị cáo là pháp nhân" vượt quá số lượng bị cáo. Hãy kiểm tra lại!');
                input.value = '0';
                input.focus();
            }
        }

        function validate() {
            var txtNgayMoPhienToa = document.getElementById('<%=txtNgayMoPhienToa.ClientID%>');
            if (!Common_CheckEmpty(txtNgayMoPhienToa.value)) {
                alert('Bạn chưa nhập "Ngày mở phiên tòa".Hãy kiểm tra lại!');
                txtNgayMoPhienToa.focus();
                return false;
            }
            //--------------
            var txtDiaDiem = document.getElementById('<%=txtDiaDiem.ClientID%>');
            if (!Common_CheckEmpty(txtDiaDiem.value)) {
                alert('Bạn chưa chọn "Địa điểm".Hãy kiểm tra lại!');
                txtDiaDiem.focus();
                return false;
            }
            //--------------
            var txtNgayBanAn = document.getElementById('<%=txtNgayBanAn.ClientID%>');
            if (!Common_CheckEmpty(txtNgayBanAn.value)) {
                alert('Bạn chưa chọn mục "Ngày bản án". Hãy kiểm tra lại!');
                txtNgayBanAn.focus();
                return false;
            }
            //----------------------
            var ddlKetQuaPhucTham = document.getElementById('<%=ddlKetQuaPhucTham.ClientID%>');
            var val = ddlKetQuaPhucTham.options[ddlKetQuaPhucTham.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!');
                ddlKetQuaPhucTham.focus();
                return false;
            }
            var value_change = "0";
            var ddlToiDanhChinh = document.getElementById('<%=ddlToiDanhVuAn.ClientID%>');
            value_change = ddlToiDanhChinh.options[ddlToiDanhChinh.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn tội danh chính của vụ án. Hãy kiểm tra lại!');
                ddlToiDanhChinh.focus();
                return false;
            }

            var ddlLyDoBanAn = document.getElementById('<%=ddlLyDoBanAn.ClientID%>');
            var val = ddlLyDoBanAn.options[ddlLyDoBanAn.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn nguyên nhân. Hãy chọn lại!');
                ddlLyDoBanAn.focus();
                return false;
            }
            //--------------
            var hddNguoiKyID = document.getElementById('<%=hddNguoiKyID.ClientID%>');
            var txtNguoiKy = document.getElementById('<%=txtNguoiKy.ClientID%>');
            if (!Common_CheckEmpty(hddNguoiKyID.value)) {
                alert('Bạn chưa chọn mục "Người ký". Hãy kiểm tra lại!');
                txtNguoiKy.focus();
                return false;
            }
            return true;
        }
        function validate_chitieu_tk() {
            //------------------
            if (!validate_CheckRadio())
                return false;

            //Các tiêu chí thống kê
            var txtSuaHinhPhatBS_BiCao = document.getElementById('<%=txtSuaHinhPhatBS_BiCao.ClientID%>');
            if (txtSuaHinhPhatBS_BiCao !== null && !Common_CheckEmpty(txtSuaHinhPhatBS_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtSuaHinhPhatBS_BiCao.focus();
                return false;
            }

            var txtSuaBoiThuongTH_BiCao = document.getElementById('<%=txtSuaBoiThuongTH_BiCao.ClientID%>');
            if (txtSuaBoiThuongTH_BiCao !== null && !Common_CheckEmpty(txtSuaBoiThuongTH_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtSuaBoiThuongTH_BiCao.focus();
                return false;
            }

            var txtSuaKhac_BiCao = document.getElementById('<%=txtSuaKhac_BiCao.ClientID%>');
            if (txtSuaKhac_BiCao !== null && !Common_CheckEmpty(txtSuaKhac_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtSuaKhac_BiCao.focus();
                return false;
            }

            var txtSuaQDAnSoTham_BiCao = document.getElementById('<%=txtSuaQDAnSoTham_BiCao.ClientID%>');
            if (txtSuaQDAnSoTham_BiCao !== null && !Common_CheckEmpty(txtSuaQDAnSoTham_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtSuaQDAnSoTham_BiCao.focus();
                return false;
            }
            var txtViPhamHan_BiCao = document.getElementById('<%=txtViPhamHan_BiCao.ClientID%>');
            if (txtViPhamHan_BiCao !== null && !Common_CheckEmpty(txtViPhamHan_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtViPhamHan_BiCao.focus();
                return false;
            }

            var txtDuyetKN_VKS_BiCao = document.getElementById('<%=txtDuyetKN_VKS_BiCao.ClientID%>');
            if (txtDuyetKN_VKS_BiCao !== null && !Common_CheckEmpty(txtDuyetKN_VKS_BiCao.value)) {
                alert('Bạn chưa nhập "Số bị cáo là cá nhân". Hãy kiểm tra lại!');
                txtDuyetKN_VKS_BiCao.focus();
                return false;
            }

            var txtSuaHinhPhatBS_PhapNhan = document.getElementById('<%=txtSuaHinhPhatBS_PhapNhan.ClientID%>');
            if (txtSuaHinhPhatBS_PhapNhan !== null && !Common_CheckEmpty(txtSuaHinhPhatBS_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtSuaHinhPhatBS_PhapNhan.focus();
                return false;
            }

            var txtSuaBoiThuongTH_PhapNhan = document.getElementById('<%=txtSuaBoiThuongTH_PhapNhan.ClientID%>');
            if (txtSuaBoiThuongTH_PhapNhan !== null && !Common_CheckEmpty(txtSuaBoiThuongTH_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtSuaBoiThuongTH_PhapNhan.focus();
                return false;
            }
            var txtSuaKhac_PhapNhan = document.getElementById('<%=txtSuaKhac_PhapNhan.ClientID%>');
            if (txtSuaKhac_PhapNhan !== null && !Common_CheckEmpty(txtSuaKhac_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtSuaKhac_PhapNhan.focus();
                return false;
            }
            var txtSuaQDAnSoTham_PhapNhan = document.getElementById('<%=txtSuaQDAnSoTham_PhapNhan.ClientID%>');
            if (txtSuaQDAnSoTham_PhapNhan !== null && !Common_CheckEmpty(txtSuaQDAnSoTham_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtSuaQDAnSoTham_PhapNhan.focus();
                return false;
            }
            var txtViPhamHan_PhapNhan = document.getElementById('<%=txtViPhamHan_PhapNhan.ClientID%>');
            if (txtViPhamHan_PhapNhan !== null && !Common_CheckEmpty(txtViPhamHan_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtViPhamHan_PhapNhan.focus();
                return false;
            }
            var txtDuyetKN_VKS_PhapNhan = document.getElementById('<%=txtDuyetKN_VKS_PhapNhan.ClientID%>');
            if (txtDuyetKN_VKS_PhapNhan !== null && !Common_CheckEmpty(txtDuyetKN_VKS_PhapNhan.value)) {
                alert('Bạn chưa nhập "Số bị cáo là pháp nhân". Hãy kiểm tra lại!');
                txtDuyetKN_VKS_PhapNhan.focus();
                return false;
            }

            //--------------
            var txtSBC_GIUNGUYEN_AN_ST = document.getElementById('<%=txtSBC_GIUNGUYEN_AN_ST.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_GIUNGUYEN_AN_ST.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA giữ nguyên án sơ thẩm, không chấp nhận K.N của VKS"');
                txtSBC_GIUNGUYEN_AN_ST.focus();
                return false;
            }
            //--------------
            var txtSBC_SUA_AN_ST = document.getElementById('<%=txtSBC_SUA_AN_ST.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_SUA_AN_ST.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA sửa án sơ thẩm, không theo hướng K.N của VKS"!');
                txtSBC_SUA_AN_ST.focus();
                return false;
            }
            //--------------
            var txtSBC_CHAPNHAN_TOANBO = document.getElementById('<%=txtSBC_CHAPNHAN_TOANBO.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_CHAPNHAN_TOANBO.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA chấp nhận toàn bộ K.N của VKS"!');
                txtSBC_CHAPNHAN_TOANBO.focus();
                return false;
            }
            //--------------
            var txtSBC_CHAPNHAN_MOTPHAN = document.getElementById('<%=txtSBC_CHAPNHAN_MOTPHAN.ClientID%>');
            if (!Common_CheckEmpty(txtSBC_CHAPNHAN_MOTPHAN.value)) {
                alert('Bạn chưa nhập "Số bị cáo TA chấp nhận một phần K.N của VKS"!');
                txtSBC_CHAPNHAN_MOTPHAN.focus();
                return false;
            }
            return true;
        }
        function validate_CheckRadio() {
        //-----------------------------
            <%--var rdAnLe = document.getElementById('<%=rdAnLe.ClientID%>');
            msg = 'Mục "Có áp dụng Án lệ"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnLe, msg))
                return false;--%>
            //-----------------------------
            var rdAnRutGon = document.getElementById('<%=rdAnRutGon.ClientID%>');
            msg = 'Mục "Án rút gọn"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdAnRutGon, msg))
                return false;
            //-----------------------------
            var rdBaoLucGD = document.getElementById('<%=rdBaoLucGD.ClientID%>');
            msg = 'Mục "Bạo lực gia đình"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdBaoLucGD, msg))
                return false;
            //-----------------------------
            var rdXetXuLuuDong = document.getElementById('<%=rdXetXuLuuDong.ClientID%>');
            msg = 'Mục "Xét xử lưu động"  bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdXetXuLuuDong, msg))
                return false;
            //-----------------------------
            var rdSuaHinhPhatBS = document.getElementById('<%=rdSuaHinhPhatBS.ClientID%>');
            msg = 'Mục "Sửa phần hình phạt bổ sung hoặc áp dụng các biện pháp tư pháp" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaHinhPhatBS, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdSuaHinhPhatBS);
                if (selected_value == 1) {
                    var txtSuaHinhPhatBS_BiCao = document.getElementById('<%=txtSuaHinhPhatBS_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtSuaHinhPhatBS_BiCao.value)) {
                        alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                        txtSuaHinhPhatBS_BiCao.focus();
                        return false;
                    }
                }
            }
            //-----------------------------
            var rdSuaBoiThuongTH = document.getElementById('<%=rdSuaBoiThuongTH.ClientID%>');
            msg = 'Mục "Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaBoiThuongTH, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdSuaBoiThuongTH);
                if (selected_value == 1) {
                    var txtSuaBoiThuongTH_BiCao = document.getElementById('<%=txtSuaBoiThuongTH_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtSuaBoiThuongTH_BiCao.value)) {
                        alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                        txtSuaBoiThuongTH_BiCao.focus();
                        return false;
                    }
                }
            }
            //-----------------------------
            var rdSuaKhac = document.getElementById('<%=rdSuaKhac.ClientID%>');
            msg = 'Mục "Sửa các phần khác" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaKhac, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdSuaKhac);
                if (selected_value == 1) {
                    var txtSuaKhac_BiCao = document.getElementById('<%=txtSuaKhac_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtSuaKhac_BiCao.value)) {
                        alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                        txtSuaKhac_BiCao.focus();
                        return false;
                    }
                }
            }
            //-----------------------------
            var rdSuaQDAnSoTham = document.getElementById('<%=rdSuaQDAnSoTham.ClientID%>');
            msg = 'Mục "Sửa quyết định của bản án sơ thẩm đối với bị cáo không có kháng cáo, kháng nghị" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdSuaQDAnSoTham, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdSuaQDAnSoTham);
                if (selected_value == 1) {
                    var txtSuaQDAnSoTham_BiCao = document.getElementById('<%=txtSuaQDAnSoTham_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtSuaQDAnSoTham_BiCao.value)) {
                        alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                        txtSuaQDAnSoTham_BiCao.focus();
                        return false;
                    }
                }
            }
            //----------------------------            
            var rdKhoiToTaiToa = document.getElementById('<%=rdKhoiToTaiToa.ClientID%>');
            msg = 'Mục "Khởi tố vụ án tại phiên tòa" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKhoiToTaiToa, msg))
                return false;
            //----------------------------            
            var rdKoRutKhangCao = document.getElementById('<%=rdKoRutKhangCao.ClientID%>');
            msg = 'Mục "Số vụ án VKS rút kháng nghị, người có kháng cáo không rút kháng cáo" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdKoRutKhangCao, msg))
                return false;
            //-----------------------------
            var rdViPhamHan = document.getElementById('<%=rdViPhamHan.ClientID%>');
            msg = 'Mục "Vi phạm hạn tạm giam trong giai đoạn xét xử" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdViPhamHan, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdViPhamHan);
                if (selected_value == 1) {
                    var txtViPhamHan_BiCao = document.getElementById('<%=txtViPhamHan_BiCao.ClientID%>');
                    if (!Common_CheckEmpty(txtViPhamHan_BiCao.value)) {
                        alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                        txtViPhamHan_BiCao.focus();
                        return false;
                    }
                }
            }
            //-----------------------------
            var rdDuyetKhangNghiVKS = document.getElementById('<%=rdDuyetKhangNghiVKS.ClientID%>');
            msg = 'Mục "Tòa án chấp nhận kháng nghị của VKS" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdDuyetKhangNghiVKS, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdDuyetKhangNghiVKS);
                if (selected_value == 1) {
                    if (selected_value == 1) {
                        var txtDuyetKN_VKS_BiCao = document.getElementById('<%=txtDuyetKN_VKS_BiCao.ClientID%>');
                        if (!Common_CheckEmpty(txtDuyetKN_VKS_BiCao.value)) {
                            alert('Bạn chưa nhập số bị cáo là cá nhân. Hãy kiểm tra lại!');
                            txtDuyetKN_VKS_BiCao.focus();
                            return false;
                        }
                    }
                }

                return true;
            }
    </script>
    <script>
        <%-- function popupChonToiDanh(BiCanID) {
     var BanAnID = document.getElementById('<%=hddID.ClientID%>').value;
     var link = "/QLAN/AHS/PhucTham/BanAn/popup/pToiDanh.aspx?aID=" + BanAnID + "&bID=" + BiCanID;
     var width = 900;
     var height = 650;
     PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
 }--%>
            //GTEL - DUCPH 29-09-2025 Them bien hddDaDongBoId de check co hien popup hay khong/
            function popupChonToiDanh(BiCanID, hddDaDongBoId) {
                var checkDaDongBo = document.getElementById(hddDaDongBoId).value;
                if (checkDaDongBo == '1') { // Nếu đã đồng bộ thì không hiện popup bắn thông báo
                    alert("Bị cáo đã được đồng bộ thành công. Phải thu hồi đồng bộ trước khi chỉnh sửa!");
                    return;
                }
                var BanAnID = document.getElementById('<%=hddID.ClientID%>').value;
                var link = "/QLAN/AHS/PhucTham/BanAn/popup/pToiDanh.aspx?aID=" + BanAnID + "&bID=" + BiCanID;
                var width = 900;
                var height = 650;
                PopupCenter(link, "Cập nhật điều luật áp dụng cho bị cáo", width, height);
            }

            function uploadStart(sender, args) {
                var fileName = args.get_fileName();
                var fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                var validFilesTypes = ["exe", "dll", "msi", "bat"];
                var isValidFile = false;
                for (var i = 0; i < validFilesTypes.length; i++) {
                    if (fileExt == validFilesTypes[i]) {
                        isValidFile = true;
                        break;
                    }
                }
                if (isValidFile) {
                    var err = new Error();
                    err.name = "Lỗi tải lên";
                    err.message = "Hệ thống không lưu trữ file định dạng (exe,dll,msi,bat). Hãy chọn lại!";
                    throw (err);
                    return false;
                } else {
                    return true;
                }
            }
    </script>

    <script type="text/javascript">
            var count_file = 0;
            function CheckKyso() {
<%--            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');

            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }--%>
            }
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
            function pageLoad(sender, args) {
                $(function () {

                    var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                    for (var selector in config) { $(selector).chosen(config[selector]); }
                });
            }

            function Loadds_bicao() {
                $("#<%= cmdReloadParent.ClientID %>").click();
            }
    </script>
</asp:Content>


