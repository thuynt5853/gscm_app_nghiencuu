<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pp_CapNhatMuonTra.aspx.cs" Inherits="WEB.GSTP.QLAN.QLHS.Popup.pp_CapNhatMuonTra" %>

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
        
        <asp:HiddenField ID="hddLichSuID" runat="server" Value="0" />
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
                                    <asp:DropDownList ID="dllCapNhatTrangThai" CssClass="chosen-select" runat="server" Width="220px" AutoPostBack="true" OnSelectedIndexChanged="dllCapNhatTrangThai_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="Đã lưu"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Cho mượn"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Đã chuyển"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblDonViNhan" runat="server" Text="Đơn vị nhận<span class='batbuoc'>(*)</span>"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddDonViNhan" CssClass="chosen-select" runat="server" Width="220px"></asp:DropDownList>

                                    <asp:TextBox ID="txtDonViNhan" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td colspan="2" style="width: 200px;">
                                    <asp:RadioButtonList RepeatDirection="Horizontal" ID="rbLoaiDonVi" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rbLoaiDonVi_SelectedIndexChanged">
                                        <asp:ListItem Text="Tòa án" Value="0" Selected="True" />
                                        <asp:ListItem Text="Viện kiểm soát" Value="1" />
                                        <asp:ListItem Text="Khác" Value="2" />
                                    </asp:RadioButtonList>
                                </td>
                                <td></td>
                            </tr>

                            <tr>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblNguoiNhan" runat="server" Text="Người nhận"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtTenNguoiNhan" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                    <%--  <asp:DropDownList ID="ddNguoinhan" Visible="false" CssClass="chosen-select" runat="server" Width="220px"></asp:DropDownList>--%>
                                </td>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblNguoiChuyen" runat="server" Text="Người chuyển<span class='batbuoc'>(*)</span>"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoichuyen" CssClass="chosen-select" runat="server" Width="220px"></asp:DropDownList>
                                </td>
                            </tr>


                            <tr>
                                <td style="width: 101px;">
                                    <asp:Label ID="lblNgayGiao" runat="server" Text="Ngày<span class='batbuoc'>(*)</span>"></asp:Label></td>
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
                                <td style="width: 150px;">
                                    <asp:Label ID="lblKhoLuuTru" runat="server" Text="Kho lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtKhoLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblKhungLuuTru" runat="server" Text="Khung lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtKhungLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblPhongLuuTru" runat="server" Text="Phông lưu trữ"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPhongLuuTru" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblSoGia" runat="server" Text="Số giá"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoGia" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblSoHop" runat="server" Text="Số hộp"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoHop" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>

                                </td>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblSoQuyen" runat="server" Text="Số cặp/quyển"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSoQuyen" runat="server" CssClass="user" Width="212px" MaxLength="500"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 150px;">
                                    <asp:Label ID="lblLyDoChuyen" runat="server" Text="Lý do chuyển"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlLyDo" CssClass="chosen-select" runat="server" Width="220px" AutoPostBack="true" OnSelectedIndexChanged="ddlLyDo_SelectedIndexChanged"></asp:DropDownList>

                                </td>
                                <td colspan="2" style="width: 300px;">
                                     <asp:TextBox ID="txtLyDo" Visible="false" runat="server" CssClass="user" Width="320px" MaxLength="500"></asp:TextBox>
                                </td>
                                <td>

                                </td>
                            </tr>

                            <tr>
                                <td style="width: 150px;">

                                    <asp:Label ID="lblGQGhichu" runat="server" Text="Ghi chú"></asp:Label>

                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGQGhichu" runat="server" CssClass="user" Width="590px" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="text-align: center;" colspan="4">
                                    <asp:Button ID="cmdCapnhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhat_Click" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                    <asp:Button ID="cmd_exels" runat="server" CssClass="buttoninput" Text="Xuất excel" OnClick="cmdExport_Click"   />
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
            <div class="  row">
                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" PageSize="10" AllowPaging="True" GridLines="None"
                    PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                    ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                    <Columns>

                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                            <HeaderTemplate>TT</HeaderTemplate>
                        </asp:TemplateColumn>

                          <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TRANGTHAIID" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENTRANGTHAI" HeaderText="Trạng thái" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>


                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Top">
                                        <HeaderTemplate>Thông tin</HeaderTemplate>
                                        <ItemTemplate>


                                             <%---1:Cho muon; 2:Hồ sơ đã chuyển ; 3: Tra HS ------%>
                                              <asp:Panel ID="pn_ChoMuon" runat="server"  >
                                                
                                                <i>Đơn vị nhận:</i><b> <%#Eval("DONVIMUON") %></b>   
                                                <br />
                                                <i>Người nhận</i>:<b> <%#Eval("TENNGUOIMUON") %></b>
                                                 <br /> 
                                                 <i>Ngày chuyển</i>:<b> <%#Eval("STRNGAYGIAONHAN") %></b>
                                                <br />
                                                 <i>Số phiếu</i>:<b> <%#Eval("SOBUTLUC") %></b>
                                                
                                                   <br />
                                                 <i>Ghi chú</i>:<b> <%#Eval("GHICHU") %></b>
                                            </asp:Panel>
                                            <%------------------------------------------------%>
                                            <asp:Panel ID="pn_Chuyen" runat="server"  >
                                                 <i>Đơn vị nhận:</i><b> <%#Eval("DONVIMUON") %></b>   
                                                <br />
                                                <i>Người nhận</i>:<b> <%#Eval("TENNGUOIMUON") %></b>
                                                 <br /> 
                                                 <i>Ngày chuyển</i>:<b> <%#Eval("STRNGAYGIAONHAN") %></b>
                                                <br />
                                                  <i>Người chuyển</i>:<b> <%#Eval("TENNGUOICHOMUON") %></b>
                                                <br />

                                                 <i>Số phiếu</i>:<b> <%#Eval("SOBUTLUC") %></b>
                                                  <br />
                                                 <i>Tên lý do</i>:<b> <%#Eval("TENLYDO") %></b>
                                                   <br />
                                                 <i>Ghi chú</i>:<b> <%#Eval("GHICHU") %></b>
                                            </asp:Panel>
                                              <%------------------------------------------------%>
                                              <asp:Panel ID="pn_NhanHoSo" runat="server"  >
                                                 <i>Đơn vị trả:</i><b> <%#Eval("DONVIMUON") %></b>   
                                                <br />
                                                <i>Người trả</i>:<b> <%#Eval("TENNGUOIMUON") %></b>
                                                 <br /> 
                                                 <i>Ngày nhận</i>:<b> <%#Eval("STRNGAYGIAONHAN") %></b>
                                                   <br /> 
                                                 <i>Người nhận</i>:<b> <%#Eval("TENNGUOICHOMUON") %></b>
                                                <br />
                                                 <i>Số phiếu</i>:<b> <%#Eval("SOBUTLUC") %></b>
                                                  <br />
                                                 <i>Kho lưu trữ</i>:<b> <%#Eval("KHOLUUTRU") %></b>
                                                   <br />
                                                   <i>Khung lưu trữ</i>:<b> <%#Eval("KHUNGLUUTRU") %></b>
                                                   <br />
                                                    <i>Phông lưu trữ</i>:<b> <%#Eval("PHONGLUUTRU") %></b>
                                                   <br />
                                                   <i>Số giá</i>:<b> <%#Eval("SOGIA") %></b>
                                                   <br />
                                                  <i>Số hộp</i>:<b> <%#Eval("SOHOP") %></b>
                                                   <br />
                                                   <i>Số cặp/quyển</i>:<b> <%#Eval("SOQUYEN") %></b>
                                                   <br />
                                                 <i>Ghi chú</i>:<b> <%#Eval("GHICHU") %></b>
                                            </asp:Panel>

                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>




                        <asp:BoundColumn DataField="DONVIMUON" HeaderText="Đơn vị nhận" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENNGUOIMUON" HeaderText="Tên người nhận" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="TENNGUOICHOMUON" HeaderText="Tên người chuyển" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOBUTLUC" HeaderText="Số bút lục" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="KHOLUUTRU" HeaderText="Kho lưu trữ" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="KHUNGLUUTRU" HeaderText="Khung lưu trữ" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="PHONGLUUTRU" HeaderText="Phông lưu trữ" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOGIA" HeaderText="Số giá" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOHOP" HeaderText="Số hộp" HeaderStyle-HorizontalAlign="Center" Visible="false"></asp:BoundColumn>
                        <asp:BoundColumn DataField="SOQUYEN" HeaderText="Số cặp/quyển" HeaderStyle-HorizontalAlign="Center"  Visible="false"></asp:BoundColumn>

                           <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>

                                                <asp:LinkButton ID="lblSua" runat="server" CausesValidation="false" Text="Cập nhật" ForeColor="#0e7eee"
                                                    CommandName="Sua" CommandArgument='<%#Eval("ID") %>' ToolTip="Cập nhật"></asp:LinkButton>
                                                </br>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Hủy" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>

                                            </ItemTemplate>
                                        </asp:TemplateColumn>

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
