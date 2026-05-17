<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.TDKT.QuyetDinh.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <style type="text/css">
        .TDKT_QD_Col1 {
            width: 140px;
        }

        .TDKT_QD_Col2 {
            width: 220px;
        }

        .TDKT_QD_Col3 {
            width: 68px;
        }

        .TDKT_QD_Col4 {
            width: 115px;
        }

        .TDKT_QD_Col5 {
            width: 56px;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="HddPageSize" Value="10" runat="server" />
    <asp:HiddenField ID="hddID" Value="0" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="6">
                            <asp:Button ID="BtnThemMoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="BtnThemMoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Đơn vị</b></td>
                        <td colspan="5">
                            <asp:DropDownList ID="DropDonVi" Width="691px" runat="server" CssClass="chosen-select" AutoPostBack="true" OnSelectedIndexChanged="DropDonVi_SelectedIndexChanged"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Danh sách kèm theo<span style="color: red;"> (*)</span></b></td>
                        <td colspan="5">
                            <asp:DropDownList ID="DropDanhSach" Width="691px" class="check" runat="server" CssClass="chosen-select"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="TDKT_QD_Col1"><b>Số QĐ<span style="color: red;"> (*)</span></b></td>
                        <td class="TDKT_QD_Col2">
                            <asp:TextBox ID="TxtSoQD" runat="server" CssClass="user" Width="200px" MaxLength="100"></asp:TextBox></td>
                        <td class="TDKT_QD_Col3"><b>Ngày QĐ<span style="color: red;"> (*)</span></b></td>
                        <td class="TDKT_QD_Col4">
                            <asp:TextBox ID="TxtNgayQD" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TxtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="TxtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        </td>
                        <td class="TDKT_QD_Col5"><b>Số điều</b></td>
                        <td>
                            <asp:DropDownList ID="DropSoDieu" runat="server" CssClass="chosen-select" Width="204px" AutoPostBack="true" OnSelectedIndexChanged="DropSoDieu_SelectedIndexChanged"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td><b>Về việc</b></td>
                        <td colspan="5">
                            <asp:TextBox ID="TxtVeViec" runat="server" CssClass="user" Width="683px" MaxLength="500"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Căn cứ</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtCanCu" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_1" runat="server">
                        <td><b>Điều 1</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu1" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_2" runat="server">
                        <td><b>Điều 2</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu2" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_3" runat="server">
                        <td><b>Điều 3</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu3" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_4" runat="server">
                        <td><b>Điều 4</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu4" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_5" runat="server">
                        <td><b>Điều 5</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu5" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_6" runat="server">
                        <td><b>Điều 6</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu6" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_7" runat="server">
                        <td><b>Điều 7</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu7" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_8" runat="server">
                        <td><b>Điều 8</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu8" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_9" runat="server">
                        <td><b>Điều 9</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu9" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr id="row_10" runat="server">
                        <td><b>Điều 10</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtDieu10" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Nơi nhận</b></td>
                        <td colspan="5">
                            <asp:TextBox runat="server" ID="TxtNoiNhan" Width="681px" CssClass="user" TextMode="MultiLine" Rows="5" MaxLength="4000"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><b>Người ký</b></td>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="TxtNguoiKy" Width="402px" CssClass="user" MaxLength="250"></asp:TextBox></td>
                        <td><b>Chức vụ</b></td>
                        <td>
                            <asp:TextBox runat="server" ID="TxtChucVu" Width="196px" CssClass="user" MaxLength="250"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Button ID="BtnXoa" runat="server" CssClass="buttoninput" Visible="false" Text="Xóa" OnClick="BtnXoa_Click" />
                            <asp:Button ID="BtnLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Validate();" OnClick="BtnLuu_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Label runat="server" ID="Lblthongbao" Style="color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
                <div style="float: left; width: 100%;">
                    <span style="margin-right: 5px;">Từ khóa</span>
                    <asp:TextBox ID="txtKey" runat="server" CssClass="user" Width="200px"></asp:TextBox>
                    <asp:Button ID="BtnTimkiem" runat="server" Style="margin-top: 10px;" CssClass="buttoninput" Text="Tìm kiếm" OnClick="BtnTimkiem_Click" />
                </div>
                <asp:Panel ID="PnlData" runat="server">
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
                        AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand">
                        <Columns>
                            <asp:BoundColumn DataField="STT" HeaderText="Thứ tự" HeaderStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="SOQD" HeaderText="Số QĐ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="NGAYQD" HeaderText="Ngày QĐ" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                            <asp:BoundColumn DataField="QD_VE_VIEC" HeaderText="Về việc" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:BoundColumn DataField="TENDONVI" HeaderText="Đơn vị" HeaderStyle-Width="300px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Thao tác</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LbtSua" runat="server" Text="Sửa" CausesValidation="false"
                                        CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="LbtXoa" runat="server" Text="Xóa" CausesValidation="false"
                                        CommandName="Xoa" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'
                                        OnClientClick="return confirm('Bạn thực sự muốn xóa quyết định này?');"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang">
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
                </asp:Panel>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {

                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            });
        }
        function Validate() {
            <%--var DropDonVi = document.getElementById('<%=DropDonVi.ClientID%>');
            var val = DropDonVi.options[DropDonVi.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn đơn vị. Hãy chọn lại.');
                DropDonVi.focus();
                return false;
            }--%>
            var DropDanhSach = document.getElementById('<%=DropDanhSach.ClientID%>');
            var val = DropDanhSach.options[DropDanhSach.selectedIndex].value;
            if (val == 0) {
                alert('Chưa chọn danh sách kèm theo. Hãy chọn lại.');
                DropDanhSach.focus();
                return false;
            }
            var TxtSoQD = document.getElementById('<%=TxtSoQD.ClientID%>');
            var Length = TxtSoQD.value.trim().length;
            if (Length == 0) {
                alert('Số QĐ không được để trống. Hãy nhập lại.');
                TxtSoQD.focus();
                return false;
            } else if (Length > 100) {
                alert('Số QĐ không được quá 100 ký tự. Hãy nhập lại.');
                TxtSoQD.focus();
                return false;
            }
            var TxtNgayQD = document.getElementById('<%=TxtNgayQD.ClientID%>');
            Length = TxtNgayQD.value.trim().length;
            if (Length == 0) {
                alert('Chưa nhập ngày QĐ. Hãy nhập lại.');
                TxtNgayQD.focus();
                return false;
            }
            else if (Length > 0) {
                if (!Common_IsTrueDate(TxtNgayQD.value)) {
                    TxtNgayQD.focus();
                    return false;
                }
                var now = new Date();
                var temp = TxtNgayQD.value.split('/');
                var DateTemp = new Date(temp[2], temp[1] - 1, temp[0]);
                if (now < DateTemp) {
                    alert('Ngày QĐ phải nhỏ hơn hoặc bằng ngày hiện tại. hãy nhập lại.');
                    TxtNgayQD.focus();
                    return false;
                }
            }
            var TxtVeViec = document.getElementById('<%=TxtVeViec.ClientID%>');
            Length = TxtVeViec.value.trim().length;
            if (Length > 500) {
                alert('Về việc không được quá 500 ký tự. Hãy nhập lại.');
                TxtVeViec.focus();
                return false;
            }
            var TxtCanCu = document.getElementById('<%=TxtCanCu.ClientID%>');
            Length = TxtCanCu.value.trim().length;
            if (Length > 4000) {
                alert('Căn cứ không được quá 4000 ký tự. Hãy nhập lại.');
                TxtCanCu.focus();
                return false;
            }
            var TxtDieu1 = document.getElementById('<%=TxtDieu1.ClientID%>');
            Length = TxtDieu1.value.trim().length;
            if (Length > 4000) {
                alert('Điều 1 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu1.focus();
                return false;
            }
            var TxtDieu2 = document.getElementById('<%=TxtDieu2.ClientID%>');
            Length = TxtDieu2.value.trim().length;
            if (Length > 4000) {
                alert('Điều 2 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu2.focus();
                return false;
            }
            var TxtDieu3 = document.getElementById('<%=TxtDieu3.ClientID%>');
            Length = TxtDieu3.value.trim().length;
            if (Length > 4000) {
                alert('Điều 3 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu3.focus();
                return false;
            }
            var TxtDieu4 = document.getElementById('<%=TxtDieu4.ClientID%>');
            Length = TxtDieu4.value.trim().length;
            if (Length > 4000) {
                alert('Điều 4 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu4.focus();
                return false;
            }
            var TxtDieu5 = document.getElementById('<%=TxtDieu5.ClientID%>');
            Length = TxtDieu5.value.trim().length;
            if (Length > 4000) {
                alert('Điều 5 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu5.focus();
                return false;
            }
            var TxtDieu6 = document.getElementById('<%=TxtDieu6.ClientID%>');
            Length = TxtDieu6.value.trim().length;
            if (Length > 4000) {
                alert('Điều 6 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu6.focus();
                return false;
            }
            var TxtDieu7 = document.getElementById('<%=TxtDieu7.ClientID%>');
            Length = TxtDieu7.value.trim().length;
            if (Length > 4000) {
                alert('Điều 7 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu7.focus();
                return false;
            }
            var TxtDieu8 = document.getElementById('<%=TxtDieu8.ClientID%>');
            Length = TxtDieu8.value.trim().length;
            if (Length > 4000) {
                alert('Điều 8 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu8.focus();
                return false;
            }
            var TxtDieu9 = document.getElementById('<%=TxtDieu9.ClientID%>');
            Length = TxtDieu9.value.trim().length;
            if (Length > 4000) {
                alert('Điều 9 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu9.focus();
                return false;
            }
            var TxtDieu10 = document.getElementById('<%=TxtDieu10.ClientID%>');
            Length = TxtDieu10.value.trim().length;
            if (Length > 4000) {
                alert('Điều 10 không được quá 4000 ký tự. Hãy nhập lại.');
                TxtDieu10.focus();
                return false;
            }
            var TxtNoiNhan = document.getElementById('<%=TxtNoiNhan.ClientID%>');
            Length = TxtNoiNhan.value.trim().length;
            if (Length > 500) {
                alert('Nơi nhận không được quá 500 ký tự. Hãy nhập lại.');
                TxtNoiNhan.focus();
                return false;
            }
            var TxtNguoiKy = document.getElementById('<%=TxtNguoiKy.ClientID%>');
            Length = TxtNguoiKy.value.trim().length;
            if (Length > 250) {
                alert('Người ký không được quá 250 ký tự. Hãy nhập lại.');
                TxtNguoiKy.focus();
                return false;
            }
            var TxtChucVu = document.getElementById('<%=TxtChucVu.ClientID%>');
            Length = TxtChucVu.value.trim().length;
            if (Length > 250) {
                alert('Chức vụ không được quá 250 ký tự. Hãy nhập lại.');
                TxtChucVu.focus();
                return false;
            }
        }
    </script>
</asp:Content>
