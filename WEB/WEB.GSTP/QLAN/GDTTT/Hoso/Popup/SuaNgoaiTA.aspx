<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SuaNgoaiTA.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.Hoso.Popup.SuaNgoaiTA" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sửa đổi thông tin đơn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
</head>
<body>
    <style type="text/css">
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .Lable_Popup_Add_VV {
            width: 117px;
        }

        .Input_Popup_Add_VV {
            width: 250px;
        }
    </style>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="boxchung">

                    <table class="table1">
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="cmdLuu" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu danh sách" OnClick="cmdLuu_Click" />
                                <asp:Button ID="cmdLuuAndNext" runat="server" CssClass="btnBuoc  bg_do" Text="Lưu & Chuyển trang" OnClick="cmdLuuAndNext_Click" />
                                <asp:Button ID="Button1" runat="server" CssClass="btnBuoc  bg_do" Text="Đóng" OnClientClick="window.close();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="width: 100%; margin-bottom: 100px;">
                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                            <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                                <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="float: left; width: 100%;">
                                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="10" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" OnItemDataBound="dgList_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>TT</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%# Container.ItemIndex + 1 %>
                                                        <asp:HiddenField ID="hddLOAIDON" runat="server" Value='<%# Eval("LOAIDON")%>' />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Ngày nhận</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNgaynhandon" runat="server" Text='<%# GetDate(Eval("NGAYNHANDON")) %>' CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgaynhandon_CalendarExtender" runat="server" TargetControlID="txtNgaynhandon" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgaynhandon_MaskedEditExtender3" runat="server" TargetControlID="txtNgaynhandon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người đề nghị, kiến nghị, thông báo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hddCV_ISTRONGNGANH" runat="server" Value='<%# Eval("CV_ISTRONGNGANH")%>' />
                                                        <asp:HiddenField ID="hddNGUOIGUI_HOTEN" runat="server" Value='<%# Eval("NGUOIGUI_HOTEN")%>' />
                                                        <asp:TextBox ID="txtNguoigui" runat="server" Text='<%# Eval("NGUOIGUI_HOTEN")%>' CssClass="user" Width="150px" MaxLength="250" Visible="false"></asp:TextBox>
                                                        <asp:DropDownList ID="ddlDonvigui" runat="server" CssClass="chosen-select" Width="150px" MaxLength="250" Visible="false"></asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="175px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Địa chỉ</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:HiddenField ID="hddTinhID" runat="server" Value='<%# Eval("NGUOIGUI_TINHID")%>' />
                                                        <asp:HiddenField ID="hddHuyenID" runat="server" Value='<%# Eval("NGUOIGUI_HUYENID")%>' />
                                                        <asp:DropDownList ID="ddlTinh" AutoPostBack="True" OnSelectedIndexChanged="ddlTinh_SelectedIndexChanged" CssClass="chosen-select" runat="server" Width="183px"></asp:DropDownList>
                                                        <asp:DropDownList ID="ddlHuyen" CssClass="chosen-select" runat="server" Width="183px"></asp:DropDownList>
                                                        <div style="margin-top: 2px;">
                                                            <asp:TextBox ID="txtDiachi" runat="server" Text='<%# Eval("NGUOIGUI_DIACHI")%>' CssClass="user" Width="175px" MaxLength="250"></asp:TextBox>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="85px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số BA/QĐ</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtSoBAQD" runat="server" Text='<%# Eval("BAQD_SO")%>' CssClass="user" Width="85px" MaxLength="50"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Ngày BA/QĐ</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNgayBAQD" runat="server" Text='<%# GetDate(Eval("BAQD_NGAYBA")) %>' CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtNgayBAQD_CalendarExtender" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" />
                                                        <cc1:MaskedEditExtender ID="txtNgayBAQD_MaskedEditExtender3" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" Century="2000" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="₫" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="," CultureThousandsPlaceholder="." CultureTimePlaceholder=":" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="290px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Tòa xét xử + Nơi chuyển</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div style="float: left; width: 99%;">Tòa xét xử</div>
                                                        <asp:HiddenField ID="hddToaXXID" runat="server" Value='<%# Eval("BAQD_TOAANID")%>' />
                                                        <asp:DropDownList ID="ddlToaXX" CssClass="chosen-select" runat="server" Width="285px"></asp:DropDownList>
                                                        <div style="float: left; width: 99%;">Nơi chuyển đến</div>
                                                        <asp:TextBox ID="txtNoichuyen" runat="server" Text='<%# Eval("CD_NTA_TENDONVI")%>' CssClass="user" Width="282px" MaxLength="250"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="10px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>SL</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%# Eval("SOLUONGDON")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="145px">
                                                    <HeaderTemplate>Ghi chú</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtGhichu" runat="server" Text='<%# Eval("GHICHU")%>' CssClass="user" Width="145px" TextMode="MultiLine" Rows="5" MaxLength="500"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </div>
                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                            <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                                <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="20" Text="20"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>

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
</body>
<script src="/UI/js/chosen.jquery.js"></script>
<script src="/UI/js/init.js"></script>
<script src="/UI/js/jquery.enhsplitter.js"></script>
<script type="text/javascript">
    function pageLoad(sender, args) {
        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
        for (var selector in config) { $(selector).chosen(config[selector]); }

    }
</script>
</html>
