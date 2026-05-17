<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pp_CapNhat.aspx.cs" Inherits="WEB.GSTP.QLAN.QLHS.Popup.pp_CapNhat" %>




<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cập nhật hồ sơ</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 550px;
            overflow: auto;
            position: absolute;
            top: 65px;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .align_right {
            text-align: right;
        }

        .link_save {
            margin-left: 0px;
            margin-right: 5px;
        }

        .button_empty {
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #044271;
            background: white;
            float: left;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <asp:HiddenField ID="hddLoaiAn" runat="server" Value="0" />
        <asp:HiddenField ID="hddCapxx" runat="server" Value="0" />

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class=" row">
            <div class="box_nd">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin lưu Hồ sơ</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td>
                                    <asp:Label ID="lblTrangThai" runat="server" Text=" Trạng thái"></asp:Label>

                                </td>
                                <td colspan="3">
                                    <asp:DropDownList ID="dllCapNhatTrangThai" CssClass="chosen-select" runat="server" Width="220px">
                                        <asp:ListItem Value="1" Text="Đã lưu"></asp:ListItem>
                                        <%--  <asp:ListItem Value="2" Text="Cho mượn"></asp:ListItem>--%>
                                        <asp:ListItem Value="3" Text="Đã chuyển"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>




                            <tr>
                                <td style="width: 101px;">
                                    <asp:Label ID="lblNgayGiao" runat="server" Text="Ngày lưu hồ sơ<span class='batbuoc'>(*)</span>"></asp:Label></td>
                                <td style="width: 220px;">
                                    <asp:TextBox ID="txtNgaygiao" runat="server" CssClass="user" Width="212px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgaygiao" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgaygiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>
                                    <asp:Label ID="lblSoButLuc" runat="server" Text="Số bút lục<span class='batbuoc'>(*)</span>"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoBuLuc" runat="server" CssClass="user" Width="212px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label2" runat="server" Text="Kho lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtKhoLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label3" runat="server" Text="Khung lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtKhungLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label4" runat="server" Text="Phông lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPhongLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label5" runat="server" Text="Số giá"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoGia" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label6" runat="server" Text="Số hộp"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoHop" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 100px;">
                                    <asp:Label ID="Label7" runat="server" Text="Số cặp/quyển"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoQuyen" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGQGhichu" runat="server" CssClass="user" Width="548px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="text-align: center;" colspan="4">
                                    <asp:Button ID="cmdCapnhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhat_Click" />

                                    <asp:Button ID="cmd_exels" runat="server" CssClass="buttoninput" Text="Xuất excel" OnClick="cmdExport_Click" />

                                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;" colspan="4">
                                    <asp:Label runat="server" ID="lbthongBaoUpdate" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>



                </div>

            </div>

            <div class="row" style="display: none">
                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" PageSize="10" AllowPaging="True" GridLines="None"
                    PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%">
                    <Columns>

                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>TT</HeaderTemplate>
                        </asp:TemplateColumn>


                        <asp:BoundColumn DataField="TENTRANGTHAI" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                        <asp:BoundColumn DataField="DONVIMUON" HeaderText="Đơn vị nhận" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENNGUOIMUON" HeaderText="Tên người nhận" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENNGUOICHOMUON" HeaderText="Tên người chuyển" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOBUTLUC" HeaderText="Số bút lục" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="KHOLUUTRU" HeaderText="Kho lưu trữ" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="KHUNGLUUTRU" HeaderText="Khung lưu trữ" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="PHONGLUUTRU" HeaderText="Phòng lưu trữ" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOGIA" HeaderText="Số giá" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOHOP" HeaderText="Số hộp" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOQUYEN" HeaderText="Số cặp/quyển" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

                    </Columns>
                    <HeaderStyle CssClass="header"></HeaderStyle>
                    <ItemStyle CssClass="chan"></ItemStyle>
                    <PagerStyle Visible="false"></PagerStyle>
                </asp:DataGrid>
            </div>
        </div>



        <script src="../../../../UI/js/chosen.jquery.js"></script>
        <script src="../../../../UI/js/init.js"></script>
        <script type="text/javascript">
            function OpenPopupCenter(pageURL, title, w, h) {
                var left = (screen.width / 2) - (w / 2);
                var top = (screen.height / 2) - (h / 2);
                var targetWin = window.open(pageURL, title, 'toolbar=no,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                return targetWin;
            }
            function ReloadParent() {
                window.onunload = function (e) {
                    opener.ReLoadGrid();
                };
                window.close();
            }
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }
        </script>
    </form>
</body>
</html>
