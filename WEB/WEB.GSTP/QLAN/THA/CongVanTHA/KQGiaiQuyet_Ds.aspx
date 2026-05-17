<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="KQGiaiQuyet_Ds.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.CongVanTHA.KQGiaiQuyet_Ds" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pn" runat="server">
                <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;" > <asp:Literal ID="lttMsg" runat="server"></asp:Literal></div>
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 75px;">Lựa chọn</td>
                                            <td style="width: 200px;">
                                                <asp:DropDownList ID="dropLoaiLuaChon" CssClass="chosen-select"
                                                    Width="180px" runat="server">
                                                </asp:DropDownList></td>
                                            <td>
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <%--<asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Panel ID="pnpaging_top" runat="server">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
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
                                    </div>
                                </div>
                            </asp:Panel>
                            <!--------------------------------------->

                            <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table2" width="100%" border="1">
                                        <tr class="header">
                                            <td width="42">
                                                <div align="center"><strong>TT</strong></div>
                                            </td>
                                            <td width="100">
                                                <div align="center"><strong>Loại</strong></div>
                                            </td>
                                            <td width="80">
                                                <div align="center"><strong>Số công văn</strong></div>
                                            </td>
                                            <td width="150">
                                                <div align="center"><strong>Ngày làm công văn/ đơn</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Yêu cầu</strong></div>
                                            </td>
                                            <td>
                                                <div align="center"><strong>Tình trạng</strong></div>
                                            </td>
                                            <td width="70">
                                                <div align="center"><strong>Thao tác</strong></div>
                                            </td>
                                        </tr>
                                </HeaderTemplate>

                                <ItemTemplate>
                                    <tr>
                                        <td><%# Container.ItemIndex + 1 %></td>
                                        <td><%# Eval("LoaiDon") %></td>
                                        <td><%# Eval("SoCV_Don") %></td>
                                        <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayCV_Don")) %></td>
                                        <td><%# Eval("TenYeuCau") %></td>
                                        <td><%#Eval("TinhTrangGQ") %></td>
                                        <td>
                                            <div class="align_center">
                                                <asp:LinkButton ID="lblSua" runat="server" Text='<%# (Convert.ToDecimal(Eval("QuyetDinhID")+"")>0)? "Sửa":"Giải quyết" %>' CausesValidation="false"
                                                    CommandName="sua" ForeColor="#0e7eee" ToolTip='<%# (Convert.ToDecimal(Eval("QuyetDinhID")+"")>0)? "Sửa":"Giải quyết" %>'
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                 &nbsp;&nbsp;
                                            <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee" CommandName="Xoa"
                                                                        CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </div>
                                        </td>
                                        <td style="display: none;">
                                             <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                             <asp:HiddenField ID="hddQuyetDinhID" runat="server" Value='<%#Eval("QuyetDinhID") %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></table></FooterTemplate>
                            </asp:Repeater>
                            <!--------------------------------------->
                            <asp:Panel ID="pnpaging_bottom" runat="server">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
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
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
            </asp:Panel>
            <div style="width: 100%; float: left;">

                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }

    </script>
</asp:Content>
