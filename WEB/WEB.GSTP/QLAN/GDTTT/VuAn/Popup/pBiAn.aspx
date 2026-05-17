<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="pBiAn.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.Popup.pBiAn" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý bị án, người liên quan vụ án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>

    <style>
        body {
            width: 96%;
            margin-left: 2%;
            min-width: 0px;
            padding-top: 5px;
        }

        .tleboxchung {
            padding: 5px 5px;
            top: 5px;
            border: solid 0px #a2c2a8;
        }
    </style>
</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                <asp:HiddenField ID="hddVuAn_ToaAnID" runat="server" Value="0" />
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />

                <div class="box">
                    <div class="form_tt">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin vụ án</h4>
                            <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                                <table class="table_info_va">
                                    <tr>
                                        <td style="width: 110px;">Vụ án:</td>
                                        <td colspan="3" style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtTenVuan" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số thụ lý:</td>
                                        <td style="width: 250px;"><b>
                                            <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal></b>
                                        </td>
                                        <td style="width: 105px">Ngày thụ lý:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số BA/QĐ:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal></b>
                                        </td>
                                        <td>Ngày BA/QĐ:</td>
                                        <td><b>
                                            <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>
                                    <%--<tr>
                                        <td>Nguyên đơn/ Người khởi kiện:</td>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_NguyenDon" runat="server"></asp:Literal></b>
                                        </td>
                                        <td>Bị đơn/ Người  bị kiện:</td>
                                        <td style="vertical-align: top;"><b>
                                            <asp:Literal ID="txtVuAn_BiDon" runat="server"></asp:Literal></b>
                                        </td>
                                    </tr>--%>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------------------->
                        <div style="float: left; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin</h4>
                            <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                                <table class="table1">

                                    <tr>
                                        <td style="width: 100px;">Loại<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:DropDownList ID="dropLoai"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropLoai_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="250">
                                                <asp:ListItem Value="0" Text="Bị án khiếu nại" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Bị án đầu vụ"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Người khiếu nại"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>

                                        <td style="width: 100px;">
                                            <asp:Label ID="lblTuCachKN" runat="server" Visible="false">Tư cách khiếu nại</asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="txtTuCachKN" CssClass="user" Visible="false"
                                                runat="server" MaxLength="250" Width="300px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 80px;">
                                            <asp:Label ID="lblHoTen" runat="server">Họ tên</asp:Label>
                                            <asp:Literal ID="lttValidHoTen" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtHoten" CssClass="user"
                                                runat="server" MaxLength="250" Width="668px"></asp:TextBox>
                                        </td>
                                        <%-- <td>Ngày khiếu nại</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayKhieuNai" runat="server" CssClass="user"
                                                Width="300px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                                TargetControlID="txtNgayKhieuNai" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"
                                                TargetControlID="txtNgayKhieuNai" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>--%>
                                    </tr>
                                    <tr>
                                        <td>Huyện</td>
                                        <td>
                                            <asp:DropDownList ID="ddlTinhHuyen" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                        </td>
                                        <td>Chi tiết</td>
                                        <td>
                                            <asp:TextBox ID="txtDiachi" Width="300"
                                                placeholder="Địa chỉ chi tiết" CssClass="user" runat="server" Text='<%# Eval("DiaChi") %>'></asp:TextBox></td>
                                    </tr>
                                    <asp:Panel ID="pnKhieuNai" runat="server" Visible="false">
                                        <tr>
                                            <td>Loại bản án</td>
                                            <td>
                                                <asp:DropDownList ID="dropLoaiBAKhieuNai"
                                                    CssClass="chosen-select" runat="server" Width="250">
                                                    <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Sơ thẩm"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Phúc thẩm"></asp:ListItem>
                                                </asp:DropDownList></td>
                                            <td>Tòa xét xử</td>
                                            <td>
                                                <asp:DropDownList ID="dropToaXXBAKhieuNai"
                                                    CssClass="chosen-select" runat="server" Width="308">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td>Số BA khiếu nại</td>
                                            <td>
                                                <asp:TextBox ID="txtSoBAKhieuNai" runat="server"
                                                    CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            </td>
                                            <td>Ngày BA khiếu nại</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAKhieuNai" runat="server" CssClass="user"
                                                    Width="300px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server"
                                                    TargetControlID="txtNgayBAKhieuNai" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                                                    TargetControlID="txtNgayBAKhieuNai" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>Nội dung</td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtNoiDungKhieuNai" runat="server"
                                                    CssClass="user" Width="668px" MaxLength="10"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </asp:Panel>
                                    <asp:Panel ID="pnBiCan" runat="server">
                                        <tr>
                                            <td>Mức án</td>
                                            <td>
                                                <asp:TextBox ID="txtMucAn" runat="server"
                                                    CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                            </td>
                                            <td colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td>Tội danh</td>
                                            <td colspan="3">
                                                <asp:DropDownList ID="dropToiDanh"
                                                    CssClass="chosen-select" runat="server" Width="250px">
                                                    <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                                </asp:DropDownList>
                                            
                                                <asp:Literal ID="lttMsgTD" runat="server"></asp:Literal>
                                                <asp:Repeater ID="rptToiDanh" runat="server" Visible="false"  OnItemCommand="rptToiDanh_ItemCommand">
                                                    <HeaderTemplate><table class="table2" style="width:100%;" border="1"></HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td style="width:50px"><%# Container.ItemIndex + 1 %></td>
                                                            <td >
                                                                <asp:HiddenField runat="server" ID="hddDSToiDanhID" Value='<%#Eval("ID") %>' />
                                                                <%#Eval("TenToiDanh") %></td>
                                                            <td style="width:50px"> 
                                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                          </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate></table></FooterTemplate>
                                                </asp:Repeater>
                                            </td>
                                        </tr>

                                    </asp:Panel>

                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                                OnClientClick="return validate();" OnClick="cmdUpdate_Click" />

                                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                                Text="Làm mới" OnClick="cmdLamMoi_Click" />

                                            <input type="button" class="buttoninput" onclick="window.close();" value="Đóng" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                            <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                                            <div class="phantrang">
                                                <div class="sobanghi" style="width: 40%; font-weight: bold; text-transform: uppercase;">
                                                    Danh sách 
                                                </div>
                                                <div style="float: right;">

                                                    <asp:Panel ID="pnPagingTop" runat="server">
                                                        <div class="sotrang" style="width: 55%; display: none;">
                                                            <asp:TextBox ID="txtTextSearch" CssClass="user"
                                                                placeholder="Nhập tên cán bộ muốn tìm kiếm"
                                                                runat="server" MaxLength="250" Width="242px" Height="24px"></asp:TextBox>
                                                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                                                Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                                                            <div style="display: none;">
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
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Tư cách tố tụng</strong></div>
                                                    </td>
                                                    <td width="80px">
                                                        <div align="center"><strong>Họ tên</strong></div>
                                                    </td>
                                                    <td width="150px">
                                                        <div align="center"><strong>Tội danh</strong></div>
                                                    </td>
                                                    <td width="80px">
                                                        <div align="center"><strong>Mức án</strong></div>
                                                    </td>
                                                    <td >
                                                        <div align="center"><strong>Nội dung khiếu nại</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <div align="center"><%# Container.ItemIndex + 1 %></div>
                                                            </td>
                                                            <td><%# Eval("DuongSu_TuCachToTung") %></td>
                                                            <td><%# Eval("TenDuongSu") %></td>

                                                            <td><%# Eval("HS_TenToiDanh") %></td>
                                                            <td><%# Eval("HS_MucAn") %></td>

                                                            <td>
                                                                <%#Eval("NoiDungKhieuNai") %></td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:LinkButton ID="lkSua" runat="server"
                                                                        Text="Sửa" ForeColor="#0e7eee"
                                                                        CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                    &nbsp;&nbsp;
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                                    <br />
                                                                    <asp:LinkButton ID="lkThemToiDanh" runat="server"
                                                                        Text="Thêm tội danh" ForeColor="#0e7eee"
                                                                        CommandName="ThemToiDanh" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                                   
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
                                            <asp:Panel ID="pnPagingBottom" runat="server">
                                                <div class="phantrang_bottom">
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
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
            </ContentTemplate>
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
    </form>
    <script>
        function validate() {

            return true;
        }

    </script>
    <script>
        function ReloadParent() {
          //  var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            window.onunload = function (e) {
                opener.LoadDsDuongSu();
            };
        }
    </script>
    <script>

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
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

    <script>

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>
</body>
</html>
