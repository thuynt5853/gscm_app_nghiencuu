<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Baocao.Thongke.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <div class="box">
        <div class="box_nd">
            <asp:UpdatePanel runat="server" ID="Ajax_Manager_Updata">
                <ContentTemplate>
                    <div id="TootbalMain">
                        <asp:HiddenField ID="hi_value_send" runat="server" Value="0" />
                        <table border="0px" cellpadding="0px" cellspacing="0px" width="100%">
                            <tr>
                                <td style="padding-top: 2px; width: 50px; padding-right: 2px; padding-left: 2px;">
                                    <asp:Button ID="cmd_exels" runat="server" Height="18px" Width="55px" CausesValidation="false"
                                        CssClass="buttom_toolbarmain" Text="Báo cáo" OnClick="cmd_exels_Click" />
                                </td>
                                <td style="padding-top: 2px; width: 50px; padding-right: 1px;">
                                    <input id="cmd_Print" class="buttom_toolbarmain" style="height: 18px; width: 55px;"
                                        type="button" value="In" onclick="javascript: CallPrint('print_users');" />
                                </td>
                                <td style="padding-left: 10px; width: 30px;">
                                    <div style="float: left; padding-right: 5px; padding-top: 3px;">Loại</div>
                                </td>
                                <td style="padding-top: 3px; width: 100px; padding-left: 5px; height: 18px; display: none">
                                    <asp:DropDownList ID="Drop_TYPES_REPORT" runat="server" Width="100px" Height="19px"
                                        AutoPostBack="true" OnSelectedIndexChanged="Drop_TYPES_REPORT_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Selected="True">Theo tháng</asp:ListItem>
                                        <asp:ListItem Value="2">Theo kỳ</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-top: 3px; width: 50px;">
                                    <asp:DropDownList ID="Drop_Wasexpre" runat="server" Height="19px" OnSelectedIndexChanged="Drop_Wasexport_SelectedIndexChanged"
                                        AutoPostBack="true">
                                        <asp:ListItem Value="0">Chưa gửi</asp:ListItem>
                                        <asp:ListItem Value="1">Đã gửi</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="padding-top: 3px; width: 50px;">
                                    <div style="float: left; padding-left: 3px;">
                                        <asp:DropDownList ID="Drop_Skin" runat="server" Height="19px" OnSelectedIndexChanged="Drop_Skin_SelectedIndexChanged"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="0">Hình sự</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td style="padding-top: 3px; width: 120px;">
                                    <div style="float: left; padding-left: 3px;">
                                        <asp:DropDownList OnSelectedIndexChanged="Drop_Options_SelectedIndexChanged" AutoPostBack="true"
                                            ID="Drop_Options" runat="server" Height="19px" Width="120px" CausesValidation="false">
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td style="padding-top: 3px; width: 50px;">
                                    <div style="float: left; padding-left: 3px;">
                                        <asp:DropDownList ID="Drop_object" runat="server" Height="19px" OnSelectedIndexChanged="DDrop_object_SelectedIndexChanged"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="H" Text="Cấp huyện"></asp:ListItem>
                                            <asp:ListItem Value="T" Text="Cấp tỉnh"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td style="padding-top: 3px;">
                                    <div style="float: right; text-align: right;">
                                        <div style="float: left; padding-right: 5px; padding-top: 1px;">Báo cáo</div>
                                        <div style="float: left;">
                                            <asp:DropDownList ID="Drop_Report_Times" runat="server" OnSelectedIndexChanged="Drop_Report_Times_SelectedIndexChanged"
                                                Width="120px" Height="19px" DataTextField="TIME_NAME" DataValueField="ID" AutoPostBack="true"
                                                CausesValidation="false">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="float: left; cursor: pointer;">
                                            <img alt="" height="18" src="/Resources/Images/table_new.ico" style="border: 0px;"
                                                width="18" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="top: 26px; bottom: 0px; clear: both; margin-top: -1px; left: 0px; overflow: auto; right: 0px;"
                        id="print_users">
                        <asp:DataGrid ID="DGList" runat="server" CssClass="cls_DGlist" AllowCustomPaging="True"
                            AutoGenerateColumns="False" BackImageUrl="/Resources/Images/Tabtherr.gif" BorderColor="#8EB4CE"
                            HorizontalAlign="Center" Width="100%" OnItemDataBound="DGList_ItemDataBound">
                            <HeaderStyle CssClass="GridHeader"></HeaderStyle>
                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <PagerStyle Font-Bold="True" ForeColor="Black" HorizontalAlign="Right" Mode="NumericPages"
                                PageButtonCount="5" PrevPageText="&amp;gt;" BorderColor="#8EB4CE" BorderStyle="Solid" />
                            <AlternatingItemStyle BackColor="White" />
                            <ItemStyle BackColor="#f9f3e2" BorderColor="Silver" Height="25px" HorizontalAlign="Center" />
                            <Columns>
                                <asp:TemplateColumn HeaderText="STT">
                                    <ItemTemplate>
                                        <%= i++ %>
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" />
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="COURT_NAME" HeaderText="Tên đơn vị" SortExpression="COURT_NAME">
                                    <HeaderStyle HorizontalAlign="Center" Width="786px" />
                                    <ItemStyle HorizontalAlign="Left" CssClass="paddingshows" />
                                </asp:BoundColumn>
                            </Columns>
                            <HeaderStyle Font-Bold="True" HorizontalAlign="Center" Font-Names="Times New Roman" />
                        </asp:DataGrid>
                        <div id="Boot_datagrid_pre">
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="cmd_exels" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <script>
        function Validate() {
            return true;
        }
    </script>
</asp:Content>
