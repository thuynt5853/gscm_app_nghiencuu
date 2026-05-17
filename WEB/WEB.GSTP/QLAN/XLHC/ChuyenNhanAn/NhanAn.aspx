<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NhanAn.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.ChuyenNhanAn.NhanAn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style type="text/css">
        input[type="checkbox"] {
            margin-right: 0px !important;
        }
          
        .dropdown-td .chosen-container {
            min-height: 32px;
        }
       
        .dropdown-td .chosen-drop {
            z-index: 9999 !important; /* đảm bảo hiển thị */
        }
        
        .dropdown-td .chosen-container-single .chosen-single {
            height: auto;
            line-height: normal;
            padding: 6px 12px;
            white-space: normal; /* nếu chữ dài */
        }
        
        .dropdown-td .chosen-container .chosen-results {
            max-height: 200px;
            overflow-y: auto;
        }


    </style>
    <asp:Panel ID="pnDanhsach" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <table class="table1">
                        <tr>
                            <td>
                                <div class="boxchung">
                                    <h4 class="tleboxchung">Tìm kiếm vụ án</h4>
                                    <div class="boder" style="padding: 10px;">
                                        <table class="table1">
                                            <tr>
                                                <td style="width: 100px;">Mã vụ việc</td>
                                                <td style="width: 260px;">
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                <td style="width: 121px;">Tên vụ việc</td>
                                                <td style="width: 242px;">
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                                <td>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số QĐ </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày QĐ</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tên tòa án chuyển</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenToa" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                <td>Trường hợp giao nhận</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTHGN" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="true"></asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày giao từ</td>
                                                <td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user"
                                                        onkeypress="return isNumber(event)" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtDenNgay" onkeypress="return isNumber(event)" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                                </td>
                                            </tr>

                                            <tr>
                                                <td>Trạng thái</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbTrangthai" runat="server"
                                                        RepeatDirection="Horizontal" AutoPostBack="True"
                                                        OnSelectedIndexChanged="rdbTrangthai_SelectedIndexChanged">
                                                        <asp:ListItem Value="0" Text="Chưa nhận" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã nhận"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td colspan="4" align="center"></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" />
                                <asp:Button ID="cmdNhanan" runat="server" CssClass="buttoninput" Text="Nhận án" OnClick="cmdNhanan_Click" />
                                <asp:Button ID="cmdHuyNhan" runat="server" CssClass="buttoninput" Text="Hủy nhận án" OnClientClick="return confirm('Bạn thực sự muốn hủy nhận án này? ');" OnClick="cmdHuyNhan_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None"
                                    PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound" OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:BoundColumn DataField="v_CHUYEN_NHAN_ANID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_MAVUAN" Visible="false" HeaderText="Mã vụ việc"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("v_CHUYEN_NHAN_ANID")%>' OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="v_TENVUAN" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_TOACHUYEN" HeaderText="Tòa án chuyển" HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_NOIDUNG" HeaderText="Nội dung" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_NGAYGIAO" HeaderText="Ngày chuyển" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_TRUONGHOPGIAONHAN" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="69px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtHuyNhan" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Hủy nhận án"
                                                    CommandName="HuyNhan" CommandArgument='<%#Eval("v_CHUYEN_NHAN_ANID") %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn hủy nhận án này? ');"></asp:LinkButton>
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
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnCapnhat" runat="server" Visible="false">
        <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
        <div class="box">
            <div class="box_nd">
                <div class="truong">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Nhận án</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">

                                <tr>
                                    <td style="width: 121px;">Mã vụ việc</td>
                                    <td style="width: 190px;">
                                        <asp:TextBox ID="txtN_Mavuviec" CssClass="user" runat="server" Width="170px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td style="width: 95px;">Tên vụ việc</td>
                                    <td>
                                        <asp:TextBox ID="txtN_Tenvuviec" CssClass="user" runat="server" Width="500px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Ngày giao</td>
                                    <td>
                                        <asp:TextBox ID="txtN_Ngaygiao" CssClass="user" runat="server" Width="170px"
                                            onkeypress="return isNumber(event)"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtN_Ngaygiao" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtN_Ngaygiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtN_Ngaygiao" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                    </td>
                                    <td>Tên tòa án giao</td>
                                    <td>
                                        <asp:TextBox ID="txtN_Toagiao" CssClass="user" runat="server" Width="500px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Trường hợp giao nhận</td>
                                    <td>
                                        <asp:TextBox ID="txtN_THGN" CssClass="user" runat="server" Width="170px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                    <td>Tên tòa án nhận</td>
                                    <td>
                                        <asp:TextBox ID="txtToanhan" CssClass="user" runat="server" Width="500px" ReadOnly="true"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Ngày nhận<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayNhan" runat="server" CssClass="user"
                                            onkeypress="return isNumber(event)"
                                            Width="170px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                    <td>Người nhận</td>
                                    <td  class="dropdown-td">
                                        <asp:DropDownList ID="ddlN_Nguoinhan" runat="server" CssClass="chosen-select" Width="500px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:Label runat="server" ID="lbthongbaoNA" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="4">
                                        <asp:Button ID="cmdCapnhat" OnClientClick="return validate();" runat="server" CssClass="buttoninput" Text="Nhận án" OnClick="cmdLuu_Click" />
                                        <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script>
        function validate() {
            var txtN_Ngaygiao = document.getElementById('<%=txtN_Ngaygiao.ClientID%>');
            if (!Common_CheckEmpty(txtN_Ngaygiao.value)) {
                alert('Bạn chưa nhập ngày giao vụ án. Hãy kiểm tra lại!');
                txtN_Ngaygiao.focus();
                return false;
            }

            if (!Common_IsTrueDate(txtN_Ngaygiao.value))
                return false;

            //---------------------
            var txtNgayNhan = document.getElementById('<%=txtNgayNhan.ClientID%>');
            if (!Common_CheckEmpty(txtNgayNhan.value)) {
                alert('Bạn chưa nhập ngày nhận vụ án. Hãy kiểm tra lại!');
                txtNgayNhan.focus();
                return false;
            }

            if (!Common_IsTrueDate(txtNgayNhan.value))
                return false;

            if (!SoSanh2Date(txtNgayNhan, 'Ngày nhận vụ án', txtN_Ngaygiao.value, 'Ngày giao vụ án')) {
                txtNgayNhan.focus;
                return false;
            }

            //-------------------
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
    </script>
    <script type="text/javascript">
        function popup_in(ID, loaivv) {

            var link = "/BaoCao/Thongtinvuviec/ViewInfo.aspx?cid=" + ID + "&ctype=" + loaivv;
            var width = 900;
            var height = 800;
            PopupReport(link, "Thông tin vụ việc", width, height);
        }
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            //OpenPopUpPage(pageURL, null, w, h);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,scrollbars=yes,resizable=yes,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>

