<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="EditCVTraoDoi.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.EditCVTraoDoi" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style>
        .col1 {
            width: 120px;
        }

        .col2 {
            width: 250px;
        }

        .col3 {
            width: 135px;
        }
    </style>
    <asp:HiddenField ID="hddCurrID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTuCachTT_BiHai_ID" runat="server" Value="0" />
    <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />

    <div class="box">
        <div class="form_tt">
            <div style="padding: 2%; width: 96%; position: relative; float: left;">
                <!-------------------------------------------------->
                <div style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                    <h4 class="tleboxchung">Quản lý công văn</h4>
                    <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                        <table class="table1">
                            <tr>
                                <td class="col1">Số thụ lý</td>
                                <td class="col2">
                                    <asp:TextBox ID="txtSoThuLy" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="202px" MaxLength="10"></asp:TextBox>
                                </td>
                                <td class="col3">Ngày thụ lý
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNgayThuLy" runat="server" CssClass="user"
                                        Width="203px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayThuLy" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="col1">Số CV<span class="batbuoc">(*)</span></td>
                                <td class="col2">
                                    <asp:TextBox ID="txtSoCV" runat="server"
                                        CssClass="user" Width="202px"></asp:TextBox>
                                </td>
                                <td class="col3">
                                    <asp:Label ID="lblNgayTH" runat="server" Text="Ngày CV"></asp:Label>
                                    <span class="batbuoc">(*)</span></td>
                                <td><%--AutoPostBack="true" OnTextChanged="txtNgayCV_TextChanged"--%>
                                    <asp:TextBox ID="txtNgayCV" runat="server" CssClass="user"
                                        Width="203px" MaxLength="10" ></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayCV" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayCV" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="Ngày nhận"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNgaynhan" runat="server" CssClass="user"
                                        Width="202px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaynhan" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgaynhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgaynhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>

                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Tòa án chuyển <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropToaAn"
                                        CssClass="chosen-select" runat="server" Width="210"
                                        AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Label ID="lblTenDV" runat="server">Đơn vị chuyển CV</asp:Label><asp:Literal ID="lttValidTenDV" runat="server" Text="<span class='batbuoc'>(*)</span>"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtDonViChuyenCV" CssClass="user"
                                        runat="server" MaxLength="250" Width="203px"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>Cán bộ được phân công</td>
                                <td>
                                    <asp:DropDownList ID="dropTTV"
                                        CssClass="chosen-select" runat="server" Width="210">
                                    </asp:DropDownList>
                                </td>
                                <td>Ngày phân công TTV</td>
                                <td>
                                    <asp:TextBox ID="txtNgayPhanCongTTV" CssClass="user"
                                        runat="server" MaxLength="10" Width="203px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server"
                                        TargetControlID="txtNgayPhanCongTTV" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server"
                                        TargetControlID="txtNgayPhanCongTTV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1"
                                        ControlToValidate="txtNgayPhanCongTTV" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Nội dung</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtNoiDung" runat="server" CssClass="user"
                                        TextMode="MultiLine" Rows="2"
                                        Width="602"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGhiChu" runat="server" CssClass="user"
                                         TextMode="MultiLine" Rows="2"
                                        Width="602px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3"><%--OnClick="cmdLamMoi_Click"--%>
                                    <asp:Button ID="cmdSave" runat="server" CssClass="buttoninput"
                                        OnClientClick="return validate();" Text="Lưu" OnClick="cmdSave_Click" />

                                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput"
                                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div class="msg_error">
                                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <!---------------------------------------------------->
                  <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                <div class="phantrang">
                    <div class="sobanghi" style="width: 40%; font-weight: bold; text-transform: uppercase;">
                        Danh sách tờ trình
                    </div>
                    <div style="float: right;">
                        <asp:Button ID="cmdThemToTrinh" runat="server"
                            CssClass="buttoninput"
                            OnClientClick="OpenPopup('')"
                            Text="Thêm tờ trình" />

                        <div style="display: none;">
                            <asp:Button ID="cmdSearch" runat="server" CssClass="buttoninput"
                                Text="Tìm kiếm" OnClick="cmdSearch_Click" />

                        </div>
                        <asp:Panel ID="pnPagingTop" runat="server">
                            <div class="sotrang" style="width: 55%; display: none;">
                                <asp:TextBox ID="txtTextSearch" CssClass="user"
                                    placeholder="Nhập tên cán bộ muốn tìm kiếm"
                                    runat="server" MaxLength="250" Width="242px" Height="24px"></asp:TextBox>
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                    Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                                <div style="display: none;">
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
                        </asp:Panel>
                    </div>
                </div>
                <table class="table2" width="100%" border="1">
                    <tr class="header">
                        <td width="60">
                            <div align="center"><strong>Vòng trình</strong></div>
                        </td>
                        <td width="80px">
                            <div align="center"><strong>Ngày</strong></div>
                        </td>

                        <td width="150px">
                            <div align="center"><strong>Cấp trình</strong></div>
                        </td>

                        <td width="150px">
                            <div align="center"><strong>Lãnh đạo</strong></div>
                        </td>
                        <td width="80px">
                            <div align="center"><strong>Ngày trả</strong></div>
                        </td>

                        <td>
                            <div align="center"><strong>Ý kiến duyệt tờ trình</strong></div>
                        </td>

                        <td width="40px">
                            <div align="center"><strong>Xóa</strong></div>
                        </td>
                    </tr>
                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <asp:Literal ID="lttLanTrinh" runat="server"></asp:Literal>
                                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYTRINH")) %></td>
                                <td><%# Eval("TENTINHTRANG") %></td>
                                <td><%# Eval("TENLANHDAO") %></td>

                                <td><%# Eval("NgayTra") %></td>
                                <td><%# String.IsNullOrEmpty(Eval("CapTrinhTiep")+"") ? "":("Yêu cầu: <b>"+Eval("CapTrinhTiep") +"</b><br/>") %>
                                    <%# String.IsNullOrEmpty(Eval("YKIEN")+"") ? "":("Chi tiết: <b>"+Eval("YKIEN") +"</b>") %>
                                </td>
                                <td>
                                    <div align="center">
                                        <div class="tooltip">
                                            <asp:ImageButton ID="cmdXoa" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                ImageUrl="~/UI/img/delete.png" Width="17px"
                                                OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" />
                                            <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
                <asp:Panel ID="pnPagingBottom" runat="server" Visible="false">
                    <div class="phantrang_bottom">
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
                <div class="msg_error">
                    <asp:Literal ID="lttMsgDS" runat="server"></asp:Literal>
                </div>
                <!---------------------------------------------->
                <div style="float: left; width: 100%; position: relative; margin-bottom: 10px;">
                    <h4 class="tleboxchung">Kết quả giải quyết công văn</h4>
                    <div class="boder" style="padding: 2%; width: 96%; position: relative;">
                        <table class="table1">
                            <tr><td>Loại</td><td colspan="3"> 
                                <asp:RadioButtonList ID="rdLoaiKQ"
                                    AutoPostBack="true"
                                                            runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdLoaiKQ_SelectedIndexChanged">
                                                            <asp:ListItem Value="0" Selected="true">Trao đổi trực tiếp</asp:ListItem>
                                                            <asp:ListItem Value="1">Qua công văn</asp:ListItem>
                                                        </asp:RadioButtonList></td></tr>
                            <tr>
                                <td class="col1">
                                    <asp:Label ID="lbNgay" runat="server" Text="Ngày trao đổi"></asp:Label><span class='batbuoc'>(*)</span></td>
                                <td class="col2">
                                     <asp:TextBox ID="txtGQ_NgayCV" runat="server" CssClass="user"
                                        Width="202px" ></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtGQ_NgayCV" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtGQ_NgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtGQ_NgayCV" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                             
                                </td>
                                <td class="col3"> <asp:Label ID="lbSoCV" runat="server" Text="Số công văn" Visible="false" ></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtGQ_SoCV" runat="server"
                                        onkeypress="return isNumber(event)"
                                        CssClass="user" Width="203px" MaxLength="10" Visible="false" ></asp:TextBox>
                                      </td>
                            </tr>
                            <tr>
                                <td>Nội dung</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGQ_NoiDung" runat="server" CssClass="user"
                                         TextMode="MultiLine" Rows="2"
                                        Width="602"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGQ_GhiChu" runat="server" CssClass="user"
                                         TextMode="MultiLine" Rows="2"
                                        Width="602px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3"><%--OnClick="cmdLamMoi_Click"--%>
                                    <asp:Button ID="cmdSaveKQ" runat="server" CssClass="buttoninput"
                                        OnClientClick="return validate_kq();" Text="Lưu" OnClick="cmdSaveKQ_Click" />

                                    <asp:Button ID="cmdXoaKQ" runat="server" CssClass="buttoninput"
                                        Text="Xóa kết quả giải quyết công văn" OnClick="cmdXoaKQ_Click" />

                                    <asp:Button ID="Button3" runat="server" CssClass="buttoninput"
                                        Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div class="msg_error">
                                        <asp:Literal ID="lttMsgKQ" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <!------------------------------------------->
              
            </div>
        </div>
    </div>
    <script>
        function OpenPopup() {
            if (!validate())
                return false;

            var hddCurrID = document.getElementById('<%=hddCurrID.ClientID%>');
            var curr_id = hddCurrID.value;
            if (curr_id > 0) {
                var pageURL = "/QLAN/GDTTT/VuAn/Popup/pToTrinhCV.aspx?vID=" + hddCurrID.value;
                var title = 'Quản lý công văn trao đổi';
                var w = 1000;
                var h = 600;
                var left = (screen.width / 2) - (w / 2) + 50;
                var top = (screen.height / 2) - (h / 2) + 50;
                var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                return targetWin;
            }
            else {
                alert('Bạn cần lưu thông tin công văn trao đổi trước khi thêm mới tờ trình!');
                return false;
            }
        }

        function validate() {
            //--------------------------------
            var txtSoCV = document.getElementById('<%=txtSoCV.ClientID%>');
            if (!Common_CheckEmpty(txtSoCV.value)) {
                alert('Bạn chưa nhập số công văn. Hãy kiểm tra lại!');
                txtSoCV.focus();
                return false;
            }
            var txtNgayCV = document.getElementById('<%=txtNgayCV.ClientID%>');
            if (!CheckDateTimeControl(txtNgayCV, 'Ngày công văn'))
                return false;
            //----------------------------
            var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
            var val = dropToaAn.options[dropToaAn.selectedIndex].value;
            if (val == 0) {
                var txtDonViChuyenCV = document.getElementById('<%=txtDonViChuyenCV.ClientID%>');
                       if (!Common_CheckEmpty(txtDonViChuyenCV.value)) {
                           alert('Bạn chưa nhập tên đơn vị gửi công văn. Hãy kiểm tra lại!');
                           txtDonViChuyenCV.focus();
                           return false;
                       }
                   }
                   //-------------------------

                   <%--var txtNgayPhanCongTTV = document.getElementById('<%=txtNgayPhanCongTTV.ClientID%>');
                   if (!CheckDateTimeControl(txtNgayPhanCongTTV, 'Ngày phân công TTV'))
                       return false;--%>
                   //----------------------------
                   return true;
        }
        function validate_kq() {
            if (!validate())
                return false;
            var txtNgayCV = document.getElementById('<%=txtGQ_NgayCV.ClientID%>');
            if (!CheckDateTimeControl(txtNgayCV, 'Ngày công văn giải quyết'))
                return false;
            return true;
        }
        function LoadDSToTrinh() {
            $("#<%= cmdSearch.ClientID %>").click();
        }

    </script>
    <script>
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
