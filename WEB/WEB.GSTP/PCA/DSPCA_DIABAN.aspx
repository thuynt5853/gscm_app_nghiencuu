<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="DSPCA_DIABAN.aspx.cs" 
    Inherits="WEB.GSTP.PCA.DSPCA_DIABAN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <style type="text/css">
        .labelTimKiem_css {
            width: 85px;
        }

        .grid_button {
            margin-right: 10px;
            float: left;
        }
    </style>
    <div class="box">
        <div class="box_nd">

            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">Tìm kiếm</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                        <td style="width: 60px;">Phó Chánh án</td>
                        <td style="width: 260px;">
                            <asp:DropDownList ID="dropLD" CssClass="chosen-select"
                                runat="server" Width="250px">
                            </asp:DropDownList>

                        </td>
                        <td style="width: 80px;">Tòa án</td>
                        <td>
                            <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                runat="server" Width="250px">
                            </asp:DropDownList>  <asp:Button ID="cmdTimkiem" runat="server" Height="26px"
                                CssClass="buttoninput" Text="Tìm kiếm" OnClick="btnTimKiem_Click" />
                              <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput" Height="26px"
                                                        Text="In biểu mẫu" OnClick="cmdPrint_Click" />
                        </td>
                    </tr>
                        </table>
                    </div>
                </div>
                <table class="table1">
                    <tr>
                        <td colspan="4">
                            <asp:Label runat="server" ID="lblThongBao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="phantrang" style="margin-bottom: 8px;">
                                <div class="sobanghi">
                                      <asp:Button ID="cmdUpdate" runat="server" Height="26px"
                                CssClass="buttoninput" Text="Lưu cấu hình" OnClick="cmdUpdate_Click" />  
                                </div>
                            </div>
                            <table class="table2" width="100%" border="1">
                                <tr class="header">
                                    <td width="10%">
                                        <div align="center"><strong>STT</strong></div>
                                    </td>
                                    <td width="45%">
                                        <div align="center"><strong>Tòa án</strong></div>
                                    </td>
                                   
                                    <td width="25%">
                                        <div align="center"><strong>Phó Chánh án</strong></div>
                                    </td>
                                    <td width="20%">
                                        <div align="center"><strong>Ngày phân công</strong></div></td>
                                </tr>
                                <asp:Repeater ID="rpt" runat="server" OnItemDataBound="rpt_ItemDataBound">
                                    <HeaderTemplate>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td align="center"><%# Eval("TT") %>
                                                <asp:HiddenField ID="hddPCAID" runat="server" Value='<%# Eval("PCAID") %>' />
                                                <asp:HiddenField ID="hddToaanID" runat="server" Value='<%# Eval("TOAANID") %>' />
                                            </td>
                                            <td><%#Eval("TEN") %></td>
                                            <td>
                                                <div>
                                                    <asp:DropDownList ID="dropLanhDao" CssClass="chosen-select"
                                                        runat="server" Width="500px">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td>
                                                <%--<asp:  DataField="BAQD_NGAYBA" HeaderText="Ngày BA/QĐ" HeaderStyle-Width="65px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center"></asp:>--%>   
                                                <asp:TextBox ID="txtNgayPC" runat="server" CssClass="user" Width="152px" MaxLength="10" Text='<%# Eval("NGAYPHANCONG") %>'></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayPC" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayPC" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></FooterTemplate>
                                </asp:Repeater>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
  
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
