<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Config.aspx.cs" Inherits="WEB.GSTP.Danhmuc.ConfigQHPLTK.Config" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>

    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .tdWidthTblToaAn {
            width: 120px;
        }
    </style>
    <div style="float: left; width: 97%; margin-left: 1.5%;">
        <div class="box">

            <div class="boder" style="float: left; width: 99%; margin-bottom: 10px;">
                <table class="table1">
                    <tr>
                        <td style="width: 95px;"><b>Tên QHPL</b>
                            <asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="80%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 50px;"><b>Loại án</b></td>
                        <td style="width: 170px;">
                            <asp:DropDownList ID="dropLoai" class="check"
                                AutoPostBack="true"
                                runat="server" CssClass="chosen-select" Width="166px" OnSelectedIndexChanged="dropLoai_SelectedIndexChanged" />
                        </td>
                        <td style="width: 100px;"><b>QHPL Thống kê</b></td>
                        <td>
                            <asp:DropDownList ID="dropQHPLTK_Edit" class="check"
                                runat="server" CssClass="chosen-select" Width="410px" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:Literal ID="lttConfigQHPL" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="float: left; width: 100%;">
                <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>

            <asp:Panel runat="server" ID="pndata">
                <div class="phantrang">
                    <div class="sobanghi">
                        <asp:Button ID="cmUpdateConfig" runat="server" CssClass="buttoninput"
                            Text="Cập nhật cấu hình" OnClick="cmUpdateConfig_Click" />
                        <div style="display: none;">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="sotrang">
                        
                        <span style="float: left; line-height: 27px; margin-right: 5px;">Tìm theo</span>
                        <asp:TextBox runat="server" ID="txttimkiem" Width="150px" CssClass="user"></asp:TextBox>
                        <asp:DropDownList ID="dropLoaiAn" runat="server" CssClass="user"
                            AutoPostBack="true" OnSelectedIndexChanged="dropLoaiAn_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:DropDownList ID="dropIsConfig" runat="server" CssClass="user"
                            AutoPostBack="true" OnSelectedIndexChanged="dropIsConfig_SelectedIndexChanged">
                            <asp:ListItem Value="2" Text="Tất cả"></asp:ListItem>
                            <asp:ListItem Value="0" Text="Chưa cấu hình"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Đã cấu hình"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                        <asp:Panel ID="pnPagingTop" runat="server">
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
                        </asp:Panel>
                    </div>
                </div>
                <table class="table2" width="100%" border="1">
                    <tr class="header">
                        <td>
                            <div align="center"><strong>Tên quan hệ</strong></div>
                        </td>
                        <td>
                            <div align="center"><strong>QHPL Thống kê</strong></div>
                        </td>
                        <td>
                            <div align="center"><strong>Sửa</strong></div>
                        </td>
                        <td>
                            <div align="center"><strong>Xóa</strong></div>
                        </td>
                    </tr>
                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><asp:HiddenField ID="hddID" runat="server" Value='<%#Eval("ID") %>' />
                                    <asp:HiddenField ID="hddOldQHPL" runat="server" Value='<%#Eval("QHPLTK_ID") %>' />
                                    <%#Eval("TenQHPL") %></td>
                                <td  style="width: 410px;">
                                    <asp:DropDownList ID="dropQHPLTK" runat="server"
                                       CssClass="chosen-select" Width="400px">
                                    </asp:DropDownList>
                                </td>
                                <td align="center" style="width: 55px;">
                                    <asp:LinkButton ID="lblSua" runat="server" Text="Sửa"
                                        CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                </td>
                                <td align="center" style="width: 55px;">
                                    <asp:LinkButton ID="lbtXoa" runat="server"
                                        CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                        ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></FooterTemplate>
                    </asp:Repeater>
                </table>

                <div class="phantrang">
                    <div class="sobanghi">
                        <asp:HiddenField ID="hdicha" runat="server" />
                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                    </div>
                    <div class="sotrang">
                        <asp:Panel ID="pnPagingBottom" runat="server">
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
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            $(function () {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }

        function Validate() {
            var dropLoai = document.getElementById('<%=dropLoai.ClientID%>');
            var value_change = dropLoai.options[dropLoai.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn loại án. Hãy kiểm tra lại!');
                dropLoai.focus();
                return false;
            }
            //----------------------
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
