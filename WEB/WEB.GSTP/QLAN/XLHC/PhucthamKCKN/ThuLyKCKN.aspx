<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThuLyKCKN.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.PhucthamKCKN.ThuLyKCKN" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin thụ lý</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr> 
                            <td>Trường hợp thụ lý</td>
                            <td colspan="3">
                                <asp:DropDownList ID="ddlLoaiThuLy" CssClass="chosen-select" runat="server" Width="377px">
                                    <asp:ListItem Value="1" Text="Thụ lý mới"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Thụ lý Xét xử lại"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 90px;">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="100px" MaxLength="10" AutoPostBack="true" OnTextChanged="ActionCopyNgayThuLy"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 105px; float: left;">Số thụ lý<span class="batbuoc">(*)</span></td>
                            <td style="width: 165px; float: left;">
                                <asp:TextBox ID="txtSoThuly" CssClass="user" runat="server" Width="150px" MaxLength="250" AutoPostBack="true" OnTextChanged="ActionCopySoThuLy"></asp:TextBox>
                            </td>
                        </tr>

                         <tr>
                            <td style="width: 90px;">Ngày thông báo<span class="batbuoc">(*)</span></td>
                            <td>
                                <asp:TextBox ID="txtNgayThongBao" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayThongBao" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThongBao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 105px; float: left;">Số thông báo<span class="batbuoc">(*)</span></td>
                            <td style="width: 165px; float: left;">
                                <asp:TextBox ID="txtSoThongBao" CssClass="user" runat="server" Width="150px" MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:Label runat="server" ID="tlb_nguoiky" Text="Người ký"></asp:Label><span class="batbuoc">(*)</span>
                            </td>
                            <td colspan="5">
                                <asp:DropDownList ID="ddlNguoiKy"
                                                CssClass="chosen-select" runat="server" Width="377px">
                                            </asp:DropDownList>
                            </td>
                        </tr>

                        <tr style="display: none;">
                            <td>Loại quan hệ</td>
                            <td>
                                <asp:DropDownList ID="ddlLoaiQuanhe" CssClass="chosen-select" runat="server" Width="98%" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiQuanhe_SelectedIndexChanged">

                                    <asp:ListItem Value="1" Text="Yêu cầu"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>Quan hệ pháp luật</td>
                            <td>
                                <asp:DropDownList ID="ddlQuanhephapluat" CssClass="chosen-select" runat="server" Width="400px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuanhephapluat_SelectedIndexChanged"></asp:DropDownList></td>
                        </tr>
                        <tr style="display: none;">
                            <td>Thời hạn giải quyết</td>
                            <td>
                                <asp:TextBox ID="txtHanThang" CssClass="user" Style="text-align: center" onkeypress="return isNumber(event)" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                                (Tháng)
                                <asp:TextBox ID="txtHanNgay" CssClass="user" Style="text-align: center" onkeypress="return isNumber(event)" runat="server" Width="40px" MaxLength="2"></asp:TextBox>
                                (Ngày)
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr style="display: none;">
                            <td>Từ ngày</td>
                            <td>
                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Đến ngày</td>
                            <td>
                                <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>Ghi chú</td>
                            <td colspan="3">
                                <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="98%" MaxLength="250"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return ValidInputData();" OnClick="btnUpdate_Click" />
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
                                        
                                        <asp:TemplateColumn HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Số thụ lý
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOTHULY") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHULY" HeaderText="Ngày thụ lý" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                            <HeaderTemplate>
                                                Số thông báo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("SOTHONGBAO") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGAYTHONGBAO" HeaderText="Ngày thông báo" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}" Visible="false"></asp:BoundColumn>
                                        
                                        <asp:BoundColumn Visible="False" DataField="NGUOIKY" HeaderText="Người ký" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
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
        
        // function copyNgayThuLy() {
        //
        //      var ngayThuly = document.getElementById('<%= txtNgaythuly.ClientID %>').value;
        //      document.getElementById('<%= txtNgayThongBao.ClientID %>').value = ngayThuly;
        // }
        //        
        // function copySoThuLy() {
        //     var soThuly = document.getElementById('<%= txtSoThuly.ClientID %>').value;
        //     document.getElementById('<%= txtSoThongBao.ClientID %>').value = soThuly;
        // }
    
        function ValidInputData() {
            var txtNgaythuly = document.getElementById('<%=txtNgaythuly.ClientID%>');
            var lengthNgayThuLy = txtNgaythuly.value.trim().length;
            if (lengthNgayThuLy === 0) {
                alert('Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy).');
                txtNgaythuly.focus();
                return false;
            }
            if (lengthNgayThuLy > 0) {
                var arr = txtNgaythuly.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy).');
                    txtNgaythuly.focus();
                    return false;
                }
            }
            var txtSoThuly = document.getElementById('<%=txtSoThuly.ClientID %>');
            var lengthSoThuLy = txtSoThuly.value.trim().length;
            if (lengthSoThuLy === 0) {
                alert('Bạn phải nhập số thụ lý!');
                txtSoThuly.focus();
                return false;
            }
            if (lengthSoThuLy > 50) {
                alert('Số thụ lý không được quá 50 ký tự. Hãy nhập lại!');
                txtSoThuly.focus();
                return false;
            }
            
            var txtSoThongBao = document.getElementById('<%=txtSoThongBao.ClientID %>');
            var lengthSoThongBao = txtSoThongBao.value.trim().length;
            if (lengthSoThongBao == 0) {
                alert('Bạn phải nhập số thông báo!');
                txtSoThongBao.focus();
                return false;
            }
            if (lengthSoThongBao > 50) {
                alert('Số thông báo không được quá 50 ký tự. Hãy nhập lại!');
                txtSoThongBao.focus();
                return false;
            }
            
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            if (txtTuNgay.value.trim().length > 0) {
                var arr = txtTuNgay.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tháng theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
            if (txtDenNgay.value.trim().length > 0) {
                var arr = txtDenNgay.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tháng theo định dạng (dd/MM/yyyy).');
                    txtDenNgay.focus();
                    return false;
                }
            }
            // var txtGhichu = document.getElementById('<%=txtGhichu.ClientID %>');
            // if (txtGhichu.value.trim().length > 250) {
            //     alert('Ghi chú không được quá 250 ký tự. Hãy nhập lại!');
            //     txtGhichu.focus();
            //     return false;
            // }
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
