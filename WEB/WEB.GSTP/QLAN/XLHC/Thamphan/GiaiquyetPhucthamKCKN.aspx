<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="GiaiquyetPhucthamKCKN.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Thamphan.GiaiquyetPhucthamKCKN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
        <asp:HiddenField ID="hddShowDetail" Value="True" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Phân công thẩm phán</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 125px;">Thẩm phán<span class="batbuoc">(*)</span></td>
                            <td style="width: 260px;">
                                <asp:DropDownList ID="ddlThamphan" AutoPostBack="true" OnSelectedIndexChanged="myListDropDown_Change" CssClass="chosen-select"
                                    runat="server" Width="250px">
                                </asp:DropDownList>
                            <td style="width: 145px;">Vai trò<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:DropDownList ID="ddlVaitro" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Ngày phân công<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayphancong" runat="server" AutoPostBack="True" OnTextChanged="txtNgayphancong_TextChanged"
                                    CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                            <td>Ngày nhận phân công <span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNhanphancong" runat="server" CssClass="user" 
                                    AutoPostBack="true" OnTextChanged="txtNhanphancong_TextChanged" 
                                    Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNhanphancong" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNhanphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtNhanphancong" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                            </td>
                        </tr>
                        <tr>

                            <td>Ngày kết thúc</td>
                            <td colspan="3">
                                <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayketthuc" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Người phân công<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlNguoiphancong" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 125px;">Thư ký</td>
                            <td style="width: 260px;">
                                <asp:DropDownList ID="ddlThuky" CssClass="chosen-select"  runat="server" Width="250px"></asp:DropDownList>
                                </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return ValidData();" />

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
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên thẩm phán
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTHAMPHAN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Người phân công
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("THAMPHANPHANCONG") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thư ký
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                               <%#Eval("THUKY") %>
                                            </ItemTemplate>

                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYKETTHUC" HeaderText="Ngày kết thúc" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID")+"#"+Eval("CANBOID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID")+"#"+Eval("CANBOID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
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
        function ValidData() {
            var ddlThamphan = document.getElementById('<%=ddlThamphan.ClientID%>');
            var val = ddlThamphan.options[ddlThamphan.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn thẩm phán. Hãy chọn lại!');
                ddlThamphan.focus();
                return false;
            }
            var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>');
            if (!CheckDateTimeControl(txtNgayphancong, 'Ngày phân công'))
                return false;

            var txtNhanphancong = document.getElementById('<%=txtNhanphancong.ClientID%>');
            if (!CheckDateTimeControl(txtNhanphancong, 'Ngày nhận phân công'))
                return false;
            //--------------------
            var ngayphancong = txtNgayphancong.value;
            var ngaynhanphancong = txtNhanphancong.value;
            if (!SoSanh2Date(ngaynhanphancong, 'Ngày nhận phân công', ngayphancong, 'Ngày phân công'))
                return false;

            //--------------------------------
            var txtNgayketthuc = document.getElementById('<%=txtNgayketthuc.ClientID%>');
            if (Common_CheckEmpty(txtNgayketthuc.value)) {
                if (!CheckDateTimeControl(txtNgayketthuc, 'Ngày kết thúc'))
                    return false;
                if (!SoSanh2Date(txtNgayketthuc, 'Ngày kết thúc', ngaynhanphancong, 'Ngày nhận phân công'))
                    return false;
            }
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
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
