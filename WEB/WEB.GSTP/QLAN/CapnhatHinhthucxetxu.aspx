<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CapnhatHinhthucxetxu.aspx.cs" Inherits="WEB.GSTP.QLAN.CapnhatHinhthucxetxu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <link href="/UI/css/bc/Manager.css" type="text/css" rel="Stylesheet">
    <link href="/UI/css/bc/TreeView.css" type="text/css" rel="Stylesheet">
    <link href="/UI/css/bc/bootstrap.css" rel="stylesheet">
    <link href="/UI/css/bc/common.css" rel="stylesheet">
    <link href="/UI/css/bc/WebResource.css" type="text/css" rel="stylesheet">

    <style type="text/css">
        .modalBackground {
            background-color: #000;
            filter: alpha(opacity=15);
            opacity: 0.65;
        }

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

    <asp:Panel ID="pnLoaiChucnang" runat="server" ClientIDMode="AutoID">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung"></h4>
                    <table class="table1">
                        <tr>
                            <td style="float: left; width: 100px">Chức năng </td>
                            <td style="float: left; width: !important;">
                                <asp:DropDownList ID="ddlLoaiChucnang" CssClass="chosen-select" runat="server" OnSelectedIndexChanged="ddlLoaiChucnang_SelectedIndexChanged" AutoPostBack="true" Width="150">
                                    <asp:ListItem Value="0" Text=" -- Chọn --"></asp:ListItem>
                                    <asp:ListItem Value="1" Text=" - Báo cáo "></asp:ListItem>
                                    <asp:ListItem Value="2" Text=" - Cập nhật dữ liệu hình thức xét xử"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnTrangchinh" runat="server" ClientIDMode="AutoID">
        <div class="box">
            <div class="box_nd">
                <div class="truong">

                    <table class="table1" style="margin: 0 auto; width: 65%; height: 250px;">
                        <tbody>
                            <tr>
                                <td style="text-align: center; font-weight: bold; font-size: 15px;">Bạn chưa chọn chức năng !
                                </td>
                            </tr>
                        </tbody>
                    </table>

                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnBaocao" runat="server" ClientIDMode="AutoID" Visible="false">
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                        <h4 class="tleboxchung"></h4>
                        <table class="table1">
                            <tr>
                                <td style="float: left; width: 100px">Báo cáo </td>
                                <td style="float: left;">
                                    <asp:DropDownList ID="ddlLoaiBaocao" CssClass="chosen-select" runat="server" OnSelectedIndexChanged="ddlLoaiBaocao_SelectedIndexChanged" AutoPostBack="true" Width="150">
<%--                                        <asp:ListItem Value="1" Text=" - Báo cáo nhập liệu"></asp:ListItem>--%>
                                        <asp:ListItem Value="2" Text=" - Báo cáo xét xử trực tuyến tỉnh huyện"></asp:ListItem>
                                        <asp:ListItem Value="3" Text=" - Báo cáo xét xử trực tuyến cán bộ"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr style="display: none;">
                                <td>
                                    <div>Phạm vi tìm kiếm</div>
                                    <asp:DropDownList CssClass="chosen-select" ID="Drop_object" runat="server">
                                        <asp:ListItem Value="TH" Selected="True" Text="Tất cả"></asp:ListItem>
                                        <asp:ListItem Value="TOICAO" Text="Tối cao"></asp:ListItem>
                                        <asp:ListItem Value="CAPCAO" Text="Cấp cao"></asp:ListItem>
                                        <asp:ListItem Value="CAPTINH" Text="Cấp tỉnh"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="1" style="float: left; width: 100px">
                                    <asp:Label ID="lblThuly_Tungay" runat="server" Text="BA/QD từ ngày"></asp:Label>
                                </td>
                                <td colspan="1" style="float: left; width: 150px">
                                    <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td colspan="1" style="float: left; width: 30px"></td>

                                <td colspan="1" style="float: left; width: 70px">
                                    <asp:Label ID="lblThuly_Denngay" runat="server" Text="Đến ngày"></asp:Label>
                                </td>
                                <td colspan="1" style="float: left; width: 150px">
                                    <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

<%--                            <tr>
                                <td colspan="1" style="display: none; width: 100px">Tình trạng thụ lý</td>
                                <td colspan="1" style="display: none; width: 150px">
                                    <asp:DropDownList ID="DropTINHTRANG_THULY" CssClass="chosen-select" runat="server" Width="150px">
                                        <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td colspan="1" style="float: left; width: 100px">Tình trạng GQ</td>
                                <td colspan="1" style="float: left; width: 150px">
                                    <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="150px">
                                        <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="+ Chưa giải quyết xong"></asp:ListItem>
                                        <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>--%>

                            <tr>
                                <td style="float: left; width: 100px">Chọn đơn vị</td>
                                <td style="float: left; width: 400px">
                                    <asp:TextBox ID="txt_courts_show" ReadOnly="true" ForeColor="Red" runat="server" TextMode="MultiLine" Rows="2" Width="400px" CssClass="textbox"></asp:TextBox>
                                </td>
                                <td style="float: left; width: 20px"></td>
                                <td style="float: left; width: 100px">
                                    <asp:Button ID="cmd_courts_selects" runat="server" Text="Chọn" OnClientClick="javascript:window_Shows_courts()"
                                        Width="130px" Height="26px" CssClass="buttoninput" OnClick="cmd_courts_selects_Click" />
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lblmsg" runat="server" Style="color: red; float: left; padding-top: 0px; font-size: 15px;"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Text="Báo cáo" OnClientClick="return ValidateInput();" OnClick="cmdPrint_Click" />
                                    <asp:Button ID="btn_NhapMoi" runat="server" CssClass="buttoninput" Text="Nhập mới" OnClick="btn_NhapMoi_Click" />
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
                <div runat="server" id="id_show_ss" style="display: none; visibility: hidden;"></div>
                <asp:Panel ID="P_window_courts" runat="server">
                    <div style="border: solid 1px #8EB4CE; width: 402px; height: 502px; background-color: White; display: block;"
                        class="modalPopup_judge" id="id_window_shows_courts">
                        <div id="id_header_window" class="header_bc" style="cursor: move; width: 400px !important;">
                            <div class="header_bc_title" style="float: left; padding-top: 3px;">
                                Chọn tòa án cần báo cáo
                            </div>
                            <div class="head_windowList">
                                <img id="cmd_close_window_courts" alt="Thoát" src="/UI/img/close_arv.png" onclick="javascript:Hiden_window_courts();" />
                            </div>
                        </div>
                        <div style="clear: both; width: 402px; height: 470px;">
                            <div style="clear: both; height: 471px; overflow: auto; width: 400px;">
                                <div style="padding-left: 25px; padding-top: 10px;">
                                    <asp:HiddenField ID="Hi_value_ID_Court" runat="server" />
                                    <asp:HiddenField ID="hi_text_courts" runat="server" />
                                    <asp:HiddenField ID="hi_value_objects" runat="server" />
                                    <asp:HiddenField ID="Show_Court_Cheks" runat="server" />
                                    <asp:TreeView ID="TreeView_Courts" runat="server" ShowCheckBoxes="All" ShowLines="true"></asp:TreeView>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </asp:Panel>


    <asp:Panel ID="pnCapnhatXXTT" runat="server" ClientIDMode="AutoID" Visible="false">
        <div class="box" style="padding-bottom: 0px;">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2">
                                <div class="boxchung">
                                    <h4 class="tleboxchung"></h4>
                                    <div class="boder" style="padding: 15px;">
                                        <table class="table1">
                                            <tr>
                                                <td>
                                                    <div style="float: left; width: 1250px">

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Điểm cầu trung tâm</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtToaAn" CssClass="user" runat="server" Width="250px" Height="26px" Enabled="false"></asp:TextBox>
                                                        </div>

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Loại án<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left; width: 250px">
                                                            <asp:DropDownList ID="ddlXXTTLoaian" CssClass="chosen-select" runat="server" AutoPostBack="true" Width="250">
                                                                <asp:ListItem Value="7" Text=" - Phá sản"></asp:ListItem>
                                                                <asp:ListItem Value="8" Text=" - Biện pháp xử lý hành chính"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Cấp xét xử<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlCapxx" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="250">
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Tên vụ án/vụ việc<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="250" Height="26px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Ngày xét xử<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtNgayxetxu" runat="server" CssClass="user" Width="250" MaxLength="10" Height="26px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayxetxu" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayxetxu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Trạng thái<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left; width: 150px">
                                                            <asp:DropDownList ID="ddlTrangthai" CssClass="chosen-select" runat="server" AutoPostBack="true" Width="250">
                                                                <asp:ListItem Value="1" Text=" - Đã xét xử"></asp:ListItem>
                                                          <%--      <asp:ListItem Value="2" Text=" - Hoãn xét xử"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text=" - Chưa xét xử"></asp:ListItem>--%>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Chủ tọa<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlChutoa" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                        <div style="float: left;">
                                                            <asp:ListBox ID="lbThuky" CssClass="chosen-select" runat="server" Width="250px" SelectionMode="Multiple" AutoPostBack="True"></asp:ListBox>
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Ghi chú</div>
                                                        <div style="float: left; width: 250px;">
                                                            <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="250" TextMode="MultiLine" Rows="1"></asp:TextBox>
                                                        </div>
                                                    </div>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Loại BA/QĐ<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlBAQD" CssClass="chosen-select" runat="server" AutoPostBack="true" Width="250px">
                                                                <asp:ListItem Value="0" Text="-- Chọn --"></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Bản án"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Quyết định"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Số BA/QĐ<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtSoBAQD" CssClass="user" runat="server" Width="80px" Height="26px"></asp:TextBox>
                                                        </div>

                                                        <div style="float: left; width: 70px; text-align: right; margin-right: 10px;">Ngày BA/QĐ<span class="batbuoc">(*)</span></div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="90px" MaxLength="10" Height="26px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        </div>
                                                    </div>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Phòng xét xử</div>
                                                        <div style="float: left; width: 250px;">
                                                            <asp:TextBox ID="txtPhongxetxu" CssClass="user" runat="server" Width="250" Height="26px"></asp:TextBox>
                                                        </div>
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Điểm cầu thành phần 1</div>
                                                        <div style="float: left; width: 250px;">
                                                            <asp:TextBox ID="txtDiemcauthanhphan1" CssClass="user" runat="server" Width="250" Height="26px"></asp:TextBox>
                                                        </div>

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Điểm cầu thành phần 2</div>
                                                        <div style="float: left; width: 250px;">
                                                            <asp:TextBox ID="txtDiemcauthanhphan2" CssClass="user" runat="server" Width="250" Height="26px"></asp:TextBox>
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
                            <td style="width: 150px;" align="left"></td>
                            <td align="left">
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:HiddenField ID="hddLoaianLoadedit" runat="server" Value="0" />
                                <asp:Button ID="cmdUpdate_Click" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi_Click" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" align="left">
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Font-Size="17px"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>



    <asp:Panel ID="pnTimkiemHTXX" runat="server" ClientIDMode="AutoID" Visible="false">
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td colspan="2">
                                <div class="boxchung">
                                    <h4 class="tleboxchung"></h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table>
                                            <tr>
                                                <td>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Loại án</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTimkiemHTXX_Loaian" CssClass="chosen-select" runat="server" OnSelectedIndexChanged="cmdTimkiemHTXX_Click" AutoPostBack="true" Width="250">
                                                                <asp:ListItem Value="7" Text=" - Phá sản"></asp:ListItem>
                                                                <asp:ListItem Value="8" Text=" - Biện pháp xử lý hành chính"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Trạng thái</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTimkiemHTXX_Trangthai" CssClass="chosen-select" runat="server" AutoPostBack="true" Width="250">
                                                                <asp:ListItem Value="1" Text=" - Đã xét xử"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text=" - Hoãn xét xử"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text=" - Chưa xét xử"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>

                                                    <div style="float: left; width: 1250px; margin-top: 8px;">
                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">Chủ tọa</div>
                                                        <div style="float: left;">
                                                            <asp:DropDownList ID="ddlTimkiemHTXX_Chutoa" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>
                                                        </div>

                                                        <div style="float: left; width: 150px; text-align: right; margin-right: 10px;">BA/QD từ ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTimkiemHTXX_BAQD_TuNgay" runat="server" CssClass="user" Width="85px" MaxLength="10" Height="26px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtTimkiemHTXX_BAQD_TuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtTimkiemHTXX_BAQD_TuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        </div>

                                                        <div style="float: left; width: 70px; text-align: right; margin-right: 10px;">đến ngày</div>
                                                        <div style="float: left;">
                                                            <asp:TextBox ID="txtTimkiemHTXX_BAQD_DenNgay" runat="server" CssClass="user" Width="85px" MaxLength="10" Height="26px"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtTimkiemHTXX_BAQD_DenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtTimkiemHTXX_BAQD_DenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
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
                            <td style="width: 150px;" align="left"></td>
                            <td align="left">
                                <asp:Button ID="cmdTimkiemHTXX" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiemHTXX_Click" />
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" align="left">

                                <div class="phantrang">
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
                                        <asp:BoundColumn DataField="LOAIAN" HeaderText="Loại án" HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENVUAN" HeaderText="Tên vụ án/ vụ việc" HeaderStyle-Width="235px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYXETXU" HeaderText="Ngày xét xử" HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SONGAYBAQD" HeaderText="Số BA/QĐ" HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENCHUTOA" HeaderText="Tên chủ tọa" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENTHUKY" HeaderText="Thư ký" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="DIEMCAU" HeaderText="Điểm cầu" HeaderStyle-Width="125px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TRANGTHAI" HeaderText="Trạng thái" HeaderStyle-Width="55px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo, ngày tạo" HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") + "," + Eval("LOAIANID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID")  + "," + Eval("LOAIANID")%>'
                                                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
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
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>














    <cc1:ModalPopupExtender ID="MP_Window_courts" runat="server" Y="100" X="350" TargetControlID="id_show_ss"
        PopupControlID="P_window_courts" CancelControlID="cmd_close_window_courts" PopupDragHandleControlID="id_header_window_courts"
        BackgroundCssClass="modalBackground" BehaviorID="mpe_courts">
    </cc1:ModalPopupExtender>

    <script type="text/javascript">
        function Hiden_window_courts() {
            document.getElementById('id_window_shows_courts').style.display = 'none';
            return false;
        }
        function window_Shows_courts() {
            TreeView_OnLoad("<%=TreeView_Courts.ClientID %>", 1);
        }
        //window.onload = TreeView_OnLoad;
        /**
         * Ham gan su kien cho cac node, duoc goi ngay khi load form xong, gan ham nay vao button goi popup
         */
        function TreeView_OnLoad(treeviewId, index) {
            //console.log("=> TreeView_OnLoad");
            //Treeview id
            var tv = document.getElementById(treeviewId);
            var links = tv.getElementsByTagName("a");
            //Xac dinh parent node
            var isParent = false;
            var divParentId = "";
            for (var i = 0; i < links.length; i++) {
                //Xac dinh the +/- (khong add su kien cho the nay)
                var imgs = links[i].getElementsByTagName("img");
                if (imgs.length === 0) {
                    //Xac dinh checkbox
                    var p = links[i].parentElement;
                    var ip = p.getElementsByTagName("input");
                    //Xac dinh ham da gan truoc do
                    var h = links[i].href;//console.log("h: " + h);
                    var f = h.substring(0, h.indexOf("("));//console.log("f: " + f);
                    //Lay value/text cua node duoc chon
                    var value = h.substring(links[i].href.indexOf(",") + 3, links[i].href.length - 2);
                    var text = links[i].innerHTML;
                    //them su kien cho the link va checkbox, chi gan khi treeview bi load lai, thay ham __doPostBack() bang ham treeview_Click()
                    if (f !== "javascript:treeview_Click") {
                        links[i].setAttribute("href", "javascript:treeview_Click(\"" + tv.id + "\",\"" + ip[0].id + "\",\"" + links[i].id + "\",\"" + value + "\",\"" + text + "\"," + isParent + ",\"" + divParentId + "\",false," + index + ")");
                        ip[0].setAttribute("onclick", "treeview_Click(\"" + tv.id + "\",\"" + ip[0].id + "\",\"" + links[i].id + "\",\"" + value + "\",\"" + text + "\"," + isParent + ",\"" + divParentId + "\",true," + index + ")");
                    }
                    //reset bien danh dau
                    isParent = false;
                    divParentId = "";
                } else {
                    isParent = true;
                    divParentId = links[i].id + "Nodes";
                }
            }
        }
        /**
         * Ham xac dinh xem checkbox hay link duoc nhan de goi ham xu ly tiep theo, tra ve chuoi danh sach duoc chon gom hai phan tu [value, text]
         */
        function treeview_Click(treeviewID, checkboxId, linkId, nodeValue, nodeText, isParent, divParentId, isCheckbox, index) {
            //console.log("=> treeview_Click");
            //console.log("treeviewID: " + treeviewID);
            //console.log("checkboxId: " + checkboxId);
            //console.log("linkId: " + linkId);
            //console.log("nodeValue: " + nodeValue);
            //console.log("nodeText: " + nodeText);
            //console.log("isParent: " + isParent);
            //console.log("isCheckbox: " + isCheckbox);            

            //tu dong chon checkbox neu click link
            if (!isCheckbox) {
                var c = document.getElementById(checkboxId);
                c.checked = !c.checked;
            }
            //Chon cay tu dong
            if (isParent) {
                treeview_ParentChecked(treeviewID, checkboxId, nodeValue, divParentId);
            } else {
                treeview_ChildChecked(treeviewID, checkboxId, nodeValue);
            }
            //Xac dinh node selected
            if (index === 1) {
                //var r = treeview_GetAllSelected(treeviewID)
                //console.log("Nodes selected value: " + r[0]);
                //console.log("Nodes selected text: " + r[1]);
                TreeView_Courts_AfterCheck(treeviewID);
            } else if (index === 2) {
                Ra_Chapters_AfterCheck(treeviewID);
            } else if (index === 3) {
                RT_Cases_AfterCheck(treeviewID);
            } else if (index === 4) {
                RT_Criminals_AfterCheck(treeviewID);
            }
        }
        /**
         * Loai bo check node
         * @param treeviewID
         */
        function treeview_Unchecked(treeviewID) {
            //console.log("=> treeview_Unchecked => treeviewID => " + treeviewID);
            var tv = document.getElementById(treeviewID);
            var ips = tv.getElementsByTagName("input");
            for (var i = 0; i < ips.length; i++) {
                ips[i].checked = false;
            }
        }
        /**
         * Ham checked/uncheck toan bo child node khi parent node duoc chon
         */
        function treeview_ParentChecked(treeviewID, checkboxId, nodeValue, divParentId) {
            //console.log("=> treeview_ParentChecked");
            var tv = document.getElementById(treeviewID);
            var div = document.getElementById(divParentId);
            var ips = div.getElementsByTagName("input");
            var isChecked = document.getElementById(checkboxId).checked;
            for (var i = 0; i < ips.length; i++) {
                ips[i].checked = isChecked;
            }
        }
        /**
         * Ham checked/uncheck parent node khi child node duoc chon
         */
        function treeview_ChildChecked(treeviewID, checkboxId, nodeValue) {
            //console.log("=> treeview_ChildChecked");//nodeValue: 0\\2\\25
            //Kiem tra toan bo nut con cua nut cha chua nut hien tai
            //Neu tat ca check/uncheck thi check/uncheck parent node
            //Tiep tuc de quy voi parent node uncheck

            //-> C1
            //bat dau tu current node
            //tim the div bao toan bo nodes chua node hien tai
            //duyet toan bo node, neu tat ca check/uncheck -> check/uncheck parent node
            //de quy voi parent node, dung lai khi toi root node

            //-> C2
            //bat dau duyet tu root node 
            //goi de quy parent node, khong de quy leaf node
            //duyet toan bo child node cua node hien tai 
            //neu toan bo child node duoc check/uncheck -> check/uncheck parent node
        }
        /**
         * Ham lay danh sach gia tri duoc chon tren treewview, tra ve mang [value,text]
         */
        function treeview_GetAllSelected(treeviewID) {
            //console.log("=> treeview_GetAllSelected");
            var tv = document.getElementById(treeviewID);
            var links = tv.getElementsByTagName("a");
            var values = "";
            var texts = "";
            for (var i = 0; i < links.length; i++) {
                //The +/-
                var imgs = links[i].getElementsByTagName("img");
                if (imgs.length === 0) {
                    //Xac dinh checkbox
                    var p = links[i].parentElement;
                    var ip = p.getElementsByTagName("input");
                    //Lay value/text cua node duoc chon
                    var value_tmp = links[i].href.split(",")[3].replace(/"/g, "").split("\\");
                    var value = value_tmp[value_tmp.length - 1];
                    var text = links[i].innerHTML;
                    if (ip[0].checked) {
                        values = values + value + ",";
                        texts = texts + text + ",";
                    }
                }
            }
            return [values, texts];
        }

        function TreeView_Courts_AfterCheck(treeviewID) {
            console.log("=> TreeView_Courts_AfterCheck");
            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = "";
            document.getElementById('<%= hi_text_courts.ClientID %>').value = "";
            document.getElementById('<%= txt_courts_show.ClientID %>').value = "";
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = "";

            var r = treeview_GetAllSelected(treeviewID);
            var valueshowid = r[0];
            var valueshotext = r[1];
            //console.log("valueshowid: " + valueshowid);
            //console.log("valueshotext: " + valueshotext);

            document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value = valueshowid.substring(0, valueshowid.length - 1);
            document.getElementById('<%= txt_courts_show.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= hi_text_courts.ClientID %>').value = valueshotext.substring(0, valueshotext.length - 1);
            document.getElementById('<%= Show_Court_Cheks.ClientID %>').value = document.getElementById('<%= txt_courts_show.ClientID %>').value;

            //in tat ca gia tri
            console.log("Hi_value_ID_Court: " + document.getElementById('<%= Hi_value_ID_Court.ClientID %>').value);
        }




        function ValidateInput() {
            var txtNgay_Tu = document.getElementById('<%=txtThuly_Tu.ClientID%>');
            if (txtNgay_Tu != null && txtNgay_Den != null) {
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Tu, 'từ ngày')) {
                    return false;
                }
                var txtNgay_Den = document.getElementById('<%=txtThuly_Den.ClientID%>');
                if (!CheckDateTimeControl_KoSoSanhNgayHienTai(txtThuly_Den, 'đến ngày')) {
                    return false;
                }
            }
            var txt_courts_show = document.getElementById('<%=txt_courts_show.ClientID%>');
            if (txt_courts_show.value == '') {
                alert('Bạn chưa chọn Tòa án lấy báo cáo');
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
