<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiThamgiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.ADS.Sotham.NguoiThamgiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <div style="width: 90%; padding: 10px;">
                        <asp:RadioButtonList ID="rdbLoai" runat="server" RepeatDirection="Horizontal" Font-Bold="true" AutoPostBack="True" OnSelectedIndexChanged="rdbLoai_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="Nhập thông tin mới" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Chọn từ đơn khởi kiện"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <asp:Panel ID="pnNew" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 125px;">Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                                <td style="width: 195px;">
                                    <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="98%">
                                    </asp:DropDownList>
                                <td style="width: 145px;">Tên người TGTT<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="99%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Tạm trú (mã HC)<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:HiddenField ID="hdd_ND_TramtruID" runat="server" />
                                    <asp:TextBox ID="txtND_TTMA" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                                <td>Nơi tạm trú chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>ĐKHKTT (Mã HC)</td>
                                <td>
                                    <asp:HiddenField ID="hddND_HKTTID" runat="server" />
                                    <asp:TextBox ID="txtND_HKTT" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                                <td>Nơi ĐKHKTT chi tiết</td>
                                <td>
                                    <asp:TextBox ID="txtND_HKTT_Chitiet" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Giới tính</td>
                                <td>
                                    <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="98%">
                                        <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>Ngày sinh</td>
                                <td>
                                    <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user" Width="90px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    Tháng sinh
                                    <asp:TextBox ID="txtND_Thangsinh" onkeypress="return isNumber(event)" CssClass="user" runat="server" Width="30px" MaxLength="2"></asp:TextBox>
                                    Năm sinh
                                    <asp:TextBox ID="txtND_Namsinh" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="60px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Người đại diện</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_Hoten" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                                <td>Chức vụ người đại diện</td>
                                <td>
                                    <asp:TextBox ID="txtNDD_Chucvu" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Ngày tham gia</td>
                                <td>
                                    <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaythamgia" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                                <td>Ngày kết thúc</td>
                                <td>
                                    <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="110px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayketthuc" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" align="center">
                                    <div>
                                        <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" align="center">
                                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                        OnClientClick="return ValidDataInput();" OnClick="btnUpdate_Click" />

                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnChon" Visible="false" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 125px;"><b>Chọn người TGTT</b></td>
                                <td>
                                    <asp:CheckBoxList ID="chkListTGTT" runat="server" RepeatDirection="Vertical"></asp:CheckBoxList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" ID="lblMsgChon" ForeColor="Red"></asp:Label>

                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:Button ID="cmdChonTGTT" runat="server" CssClass="buttoninput" Text="Chọn đưa vào thụ lý Sơ thẩm" OnClick="cmdChonTGTT_Click" />

                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>

            <div class="truong">
                <table class="table1">

                    <tr>
                        <td colspan="2">


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
                                    OnItemCommand="dgList_ItemCommand">
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
                                                Họ và tên
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("HOTEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Địa chỉ tạm trú
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("Tamtru") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tư cách TGTT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTC") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYKETTHUC" HeaderText="Ngày kết thúc" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>

                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
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
        function ValidDataInput() {
            var ddlTucachTGTT = document.getElementById('<%=ddlTucachTGTT.ClientID%>');
            var val = ddlTucachTGTT.options[ddlTucachTGTT.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn tư cách tham gia tố tụng. Hãy chọn lại!');
                ddlTucachTGTT.focus();
                return false;
            }

            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            if (!Common_CheckTextBox(txtHoten, "Họ tên người tham gia tố tụng")) {
                     return false;
                 }
                 var lengthHoten = txtHoten.value.trim().length;
                 if (lengthHoten > 250) {
                     alert('Họ tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!');
                     txtHoten.focus();
                     return false;
                 }

                 var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (!CheckDateTimeControl(txtNgaythamgia, "Ngày tham gia"))
                return false;

            var txtND_TTChitiet = document.getElementById('<%=txtND_TTChitiet.ClientID%>');
            if (Common_CheckEmpty(txtND_TTChitiet.value)) {
                if (txtND_TTChitiet.value.trim().length > 250) {
                    alert('Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtND_TTChitiet.focus();
                    return false;
                }
            }

            var txtND_HKTT_Chitiet = document.getElementById('<%=txtND_HKTT_Chitiet.ClientID%>');
            if (Common_CheckEmpty(txtND_HKTT_Chitiet.value)) {
                if (txtND_HKTT_Chitiet.value.trim().length > 250) {
                    alert('Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtND_HKTT_Chitiet.focus();
                    return false;
                }
            }

            var txtND_Ngaysinh = document.getElementById('<%=txtND_Ngaysinh.ClientID%>');
            if (Common_CheckEmpty(txtND_Ngaysinh.value)) {
                if (!CheckDateTimeControl(txtND_Ngaysinh.value))
                    return false;
            }

            var txtNDD_Hoten = document.getElementById('<%=txtNDD_Hoten.ClientID%>');
            if (Common_CheckEmpty(txtNDD_Hoten.value)) {
                if (txtNDD_Hoten.value.trim().length > 250) {
                    alert('Tên người đại diện không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtNDD_Hoten.focus();
                    return false;
                }
            }
            return true;
        }
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';

                $("[id$=txtND_HKTT]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddND_HKTTID]").val(i.item.val); }, minLength: 1
                });

                $("[id$=txtND_TTMA]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hdd_ND_TramtruID]").val(i.item.val); }, minLength: 1
                });
            });
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>


</asp:Content>
