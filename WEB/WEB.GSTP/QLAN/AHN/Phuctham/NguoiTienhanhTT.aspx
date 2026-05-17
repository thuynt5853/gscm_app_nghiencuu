<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiTienhanhTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AHN.Phuctham.NguoiTienhanhTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <script src="../../../UI/js/Common.js"></script> <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tiến hành tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 144px;">Vai trò tham gia tố tụng<span class="batbuoc">(*)</span></td>
                            <td style="width: 260px;">
                                <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlTucachTGTT_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 145px;"></td>
                            <td></td>
                        </tr>
                        <asp:Panel ID="pnThamphan" runat="server">
                            <tr>
                                <td>Tên thẩm phán<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                <td>Người phân công</td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoiphancong" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnHTND" runat="server" Visible="false">
                            <tr>
                                <td>
                                    <asp:Label ID="lblHTND" runat="server"></asp:Label><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                <td>Người phân công</td>
                                <td>
                                    <asp:DropDownList ID="ddlHTND_NguoiPC" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnKSV" runat="server" Visible="false">
                            <tr>
                                <td>Kiểm sát viên<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="ddlKSV_Nguoi" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="pnPhancong" runat="server">
                            <tr>
                                <td>Ngày phân công</td>
                                <td>
                                    <asp:TextBox ID="txtNgayphancong" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td>Ngày nhận phân công </td>
                                <td>
                                    <asp:TextBox ID="txtNhanphancong" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNhanphancong" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNhanphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtNhanphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                </td>
                            </tr>
                        </asp:Panel>
                        <tr>
                            <td>Ngày kết thúc</td>
                            <td>
                                <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayketthuc" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" OnClientClick="return ValidInputData();" Text="Lưu" OnClick="btnUpdate_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
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
                                    OnItemCommand="dgList_ItemCommand"  OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="240px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Vai trò tiến hành tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENVAITRO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Họ và tên
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENNGUOITHTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NguoiPhanCong" HeaderText="Người phân công" HeaderStyle-Width="140px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYKETTHUC" HeaderText="Ngày kết thúc" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
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
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ValidInputData() {
            var value_change = "";
            var ddlTucachTGTT = document.getElementById('<%=ddlTucachTGTT.ClientID%>');
             var tucachtt = ddlTucachTGTT.options[ddlTucachTGTT.selectedIndex].value;
             if ((tucachtt == "THAMPHAN") || (tucachtt == "THAMPHANHDXX") || (ddlTucachTGTT == "THAMPHANDUKHUYET")) {
                 var ddlThamphan = document.getElementById('<%=ddlThamphan.ClientID%>');
                 value_change = ddlThamphan.options[ddlThamphan.selectedIndex].value;
                 if (value_change == 0) {
                     alert('Bạn chưa chọn thẩm phán. Hãy chọn lại!');
                     ddlThamphan.focus();
                     return false;
                 }
             }
             else {
                 if ((tucachtt == "HTND") || (tucachtt == "THUKY") || (tucachtt == "THUKYDUKHUYET")) {
                     var ddlHTND_Thuky = document.getElementById('<%=ddlHTND_Thuky.ClientID%>');
                     value_change = ddlHTND_Thuky.options[ddlHTND_Thuky.selectedIndex].value;
                     if (tucachtt == "HTND") {
                         if (value_change == 0) {
                             alert('Bạn chưa chọn Hội thẩm nhân dân. Hãy chọn lại!');
                             ddlHTND_Thuky.focus();
                             return false;
                         }
                     }
                     else if (tucachtt == "THUKY" || tucachtt == "THUKYDUKHUYET") {
                         if (value_change == 0) {
                             alert('Bạn chưa chọn thư ký. Hãy chọn lại!');
                             ddlHTND_Thuky.focus();
                             return false;
                         }
                     }
                 }

                 if (tucachtt == "KSV") {
                     var ddlKSV_Nguoi = document.getElementById('<%=ddlKSV_Nguoi.ClientID%>');
                    value_change = ddlKSV_Nguoi.options[ddlKSV_Nguoi.selectedIndex].value;
                    if (value_change == 0) {
                        alert('Bạn chưa chọn kiểm sát viên. Hãy chọn lại!');
                        ddlKSV_Nguoi.focus();
                        return false;
                    }
                }
             }
             //--------------------------------
             var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>');
             if (Common_CheckEmpty(txtNgayphancong.value)) {
                 if (!Common_IsTrueDate(txtNgayphancong.value))
                     return false;

             }

             var txtNhanphancong = document.getElementById('<%=txtNhanphancong.ClientID%>');
             if (Common_CheckEmpty(txtNhanphancong.value)) {
                 if (!Common_IsTrueDate(txtNhanphancong.value))
                     return false;
                 if (Common_CheckEmpty(txtNgayphancong.value)) {
                     if (!SoSanh2Date(txtNhanphancong, 'Ngày nhận phân công', txtNgayphancong.value, 'Ngày phân công'))
                         return false;
                 }
             }

             var txtNgayketthuc = document.getElementById('<%=txtNgayketthuc.ClientID%>');
            if (Common_CheckEmpty(txtNgayketthuc.value)) {
                if (!Common_IsTrueDate(txtNgayketthuc.value))
                    return false;
                if (!SoSanh2Date(txtNgayketthuc, 'Ngày kết thúc', txtNhanphancong.value, 'Ngày nhận phân công'))
                    return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
