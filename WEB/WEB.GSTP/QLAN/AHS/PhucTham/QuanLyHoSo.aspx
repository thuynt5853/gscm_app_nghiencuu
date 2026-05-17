<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="QuanLyHoSo.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.QuanLyHoSo" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddIsShowCommand" Value="True" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <h4 class="tleboxchung">QUẢN LÝ HỒ SƠ</h4>
                    <div class="boder" style="padding: 10px; margin-top: 5PX;">
                        <table class="table1">
                            <tr>
                                <td>
                                    <div style="width: 1100px; float: left">
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">Loại<span class="batbuoc">(*)</span></div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:DropDownList ID="dropLoai"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropLoai_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="243">
                                                <asp:ListItem Value="1" Text="Chuyển hồ sơ" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Nhận hồ sơ"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div style="width: 1100px; float: left; margin-top: 7px;">
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">
                                            <asp:Label runat="server" ID="lbl_DV_chuyen_nhan" Text="Đơn vị nhận"></asp:Label>
                                        </div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:RadioButtonList ID="rdLoaiDV" runat="server" Font-Bold="true"
                                                RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdLoaiDV_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="Tòa án nhân dân"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Viện kiểm sát" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                        <div style="float: left; margin-left: 15px;">
                                            <asp:DropDownList ID="dropToaAn_VKS"
                                                CssClass="chosen-select" runat="server" Width="326">
                                            </asp:DropDownList>                                            
                                        </div>
                                    </div>
                                    <div style="width: 1100px; float: left; margin-top: 7px;">
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">
                                            <asp:Label runat="server" ID="tlb_canbo" Text="Người chuyển"></asp:Label><span class="batbuoc">(*)</span>
                                        </div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:DropDownList ID="dropCanBo"
                                                CssClass="chosen-select" runat="server" Width="242px">
                                            </asp:DropDownList>
                                        </div>
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">
                                            <asp:Label runat="server" ID="lbl_ngay" Text="Ngày chuyển"></asp:Label><span class="batbuoc">(*)</span>
                                        </div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:TextBox ID="txtNgayChuyenNhan" runat="server" CssClass="user"
                                                Width="90px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayChuyenNhan" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayChuyenNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayChuyenNhan" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                        </div>
                                    </div>
                                    <div style="width: 1100px; float: left; margin-top: 7px;" runat="server" id="nguoinhan_div">
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">
                                            <asp:Label runat="server" ID="Label1" Text="Người nhận"></asp:Label>
                                        </div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:TextBox ID="txt_NGUOI_NHAN_VKS" runat="server" CssClass="user"
                                                Width="234px"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div style="width: 1100px; float: left; margin-top: 7px;">
                                        <div style="width: 100px; float: left; text-align: right; padding-top: 5px;">
                                            Ghi chú
                                        </div>
                                        <div style="float: left; margin-left: 5px;">
                                            <asp:TextBox ID="txtGhiChu" runat="server" CssClass="user"
                                                Width="572px"></asp:TextBox>
                                        </div>
                                    </div>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="width: 1100px; float: left; margin-top: 7px; margin-top: 20px;">
                                        <div style="float: left; margin-left: 103px;">
                                            <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClientClick="return validate();" OnClick="cmdUpdateAndNext_Click" />
                                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput"
                                                Text="Làm mới" OnClick="cmdLamMoi_Click" />
                                            <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput"
                                                Text="Tìm kiếm" OnClick="Btntimkiem_Click" Visible="false"/>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="width: 1100px; float: left; margin-top: 7px;">
                                        <div style="float: left; margin-left: 103px; margin-top: 10px;">
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:HiddenField ID="Hi_update" runat="server" />
                                    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                                    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                                    <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
                                    <div class="phantrang">
                                        <div class="sobanghi" style="width: 40%; font-weight: bold; text-transform: uppercase;">
                                            Danh sách 
                                        </div>
                                        <div style="float: right;">
                                            <div style="display:none;">
                                                <asp:Button ID="cmdPrinDS" runat="server" CssClass="buttoninput" Text="In danh sách" 
                                                    OnClick="cmdPrinDS_Click"/>
                                            </div>
                                            <asp:Panel ID="pnPagingTop" runat="server">
                                                <div class="sotrang" style="width: 55%; display: none;">
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
                                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_canhbao_ItemCreated" >
                                            <HeaderTemplate>
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td style="width: 100px">
                                                        <div style="text-align: center"><strong>Cán bộ</strong></div>
                                                    </td>
                                                    <td style="width: 100px">
                                                        <div style="text-align: center"><strong>Ngày nhận/ chuyển</strong></div>
                                                    </td>
                                                    <td style="width: 130px">
                                                        <div style="text-align: center"><strong>Loại</strong></div>
                                                    </td>
                                                    <td style="width: 180px">
                                                        <div style="text-align: center"><strong>Đơn vị nhận/ chuyển</strong></div>
                                                    </td>                                                  
                                                    <td>
                                                        <div align="center"><strong>Ghi chú</strong></div>
                                                    </td>
                                                    <td width="70px">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <div align="center"><%# Eval("STT") %></div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: left;"><%# Eval("TENCANBO") %></div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: center;"><%# Eval("NGAY_NC") %></div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: left;"><%# Eval("LOAI_CN") %></div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: left;"><%# Eval("DV_GUI_NHAN") %></div>
                                                    </td>                                                    
                                                    <td><%#Eval("GHICHU") %>
                                                        <%--<%#  (Convert.ToDecimal( Eval("OldVuAnID") )>0)? ("Hồ sơ được mượn từ vụ án số BA: "+ Eval("SoAnPhucTham")):""  %>--%></td>
                                                    <td>
                                                        <div align="center">
                                                            <asp:LinkButton ID="lkSua" runat="server" ToolTip='<%#Eval("ID") %>'
                                                                Text="Sửa" ForeColor="#0e7eee"
                                                                CommandName="Sua" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                            &nbsp;&nbsp;
                                                                    <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                                                                        Text="Xóa" ForeColor="#0e7eee"
                                                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                                                                        OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                        </div>
                                                    </td>
                                                     <td style="display: none;">
                                                        <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                                    </td>

                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </table>
                                    <asp:Panel ID="pnPagingBottom" runat="server">
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
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function validate() {
            var dropLoai = document.getElementById('<%= dropLoai.ClientID %>').value;
            //alert(dropLoai);
            if (dropLoai == '1') {
                var txtNgayChuyenNhan = document.getElementById('<%=txtNgayChuyenNhan.ClientID%>');
                if (!Common_CheckEmpty(txtNgayChuyenNhan.value)) {
                    alert('Bạn chưa nhập mục "Ngày chuyển"');
                    txtNgayChuyenNhan.focus();
                    return false;
                }
            }
            else if (dropLoai == '2') {
                 var txtNgayChuyenNhan = document.getElementById('<%=txtNgayChuyenNhan.ClientID%>');
                if (!Common_CheckEmpty(txtNgayChuyenNhan.value)) {
                    alert('Bạn chưa nhập mục "Ngày nhận"');
                    txtNgayChuyenNhan.focus();
                    return false;
                }
            }
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
