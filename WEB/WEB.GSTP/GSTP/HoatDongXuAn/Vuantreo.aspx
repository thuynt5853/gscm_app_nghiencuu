<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Vuantreo.aspx.cs" Inherits="WEB.GSTP.GSTP.HoatDongXuAn.Vuantreo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        input[type=checkbox] {
            margin: 2px 9px 2px 0px;
        }

        .table2 td a {
            color: #333333;
            text-decoration: none;
        }

            .table2 td a:hover {
                color: #0E7EEE;
            }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Tìm kiếm</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td><b>Tên vụ án, vụ việc</b></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtTenVuAn" runat="server" CssClass="user" Width="350px" MaxLength="50"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 105px;"><b>Số BA/QĐ</b></td>
                            <td style="width: 162px;">
                                <asp:TextBox ID="txtSoBAQD" runat="server" CssClass="user" Width="125px" MaxLength="50"></asp:TextBox>
                            </td>
                            <td style="width: 80px;"><b>Ngày BA/QĐ</b></td>
                            <td>
                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="94px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td colspan="3">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validate();" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td>
                            <span style="font-weight: bold; text-transform: uppercase;">Danh sách các vụ án treo</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="lblthongbao" ForeColor="Red" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="phantrang" id="PhanTrangTren" runat="server">
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
                                AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                                <Columns>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate><%#Container.ItemIndex +1%></ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderText="Tên vụ án" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtTenVuAn" runat="server" CausesValidation="false" Text='<%#Eval("TENVUAN") %>' CommandName="ChiTiet" CommandArgument='<%#Eval("VuAnID") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="TenToaAn" HeaderText="Tòa xử" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="200px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="SoBiCao" HeaderText="Số bị cáo được hưởng án treo" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="90px" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TenMaGiaiDoan" HeaderText="Giai đoạn" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="80px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="MAVUAN" HeaderText="Mã vụ án" HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="header_td" HeaderStyle-Width="100px"></asp:BoundColumn>
                                </Columns>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle Visible="false"></PagerStyle>
                            </asp:DataGrid>
                            <div class="phantrang" id="PhanTrangDuoi" runat="server">
                                <div class="sobanghi">
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
    <script type="text/javascript">
        function validate() {
            var txtNgayBAQD = document.getElementById('<%=txtNgayBAQD.ClientID%>');
            if (txtNgayBAQD.value.trim().length > 0) {
                if (!IsTrueDate(txtNgayBAQD.value)) {
                    alert('Ngày quyết định phải là kiểu ngày tháng (dd/MM/yyyy)');
                    txtNgayBAQD.focus();
                    return false;
                }
            }
            return true;
        }
        function CallPopupInforAHS() {
            var link = "/BaoCao/Thongtinvuviec/HinhSu.aspx";
            var width = 1000;
            var height = 700;
            PopupCenter(link, "Thông tin án Hình sự", width, height);
        }
    </script>
</asp:Content>
