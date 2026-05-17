<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ChuyenAn.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.ChuyenNhanAn.ChuyenAn" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <style type="text/css">
        input[type="checkbox"] {
            margin-right: 0px !important;
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
                                                <td style="width: 105px;">Mã vụ việc</td>
                                                <td style="width: 260px;">
                                                    <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                <td style="width: 75px;">Tên vụ việc</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Thụ lý từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="100px" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="100px" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Số quyết định</td>
                                                <td>
                                                    <asp:TextBox ID="txtSoquyetdinh" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                                <%--<td>Số bản án</td>
                                                <td>
                                                    <asp:TextBox ID="txtSobanan" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                                </td>--%>
                                                <td>Tên đương sự</td>
                                                <td>
                                                    <asp:TextBox ID="txtTenduongsu" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tòa án nhận</td>
                                                <td>
                                                    <asp:HiddenField ID="hddToaAnNhan" runat="server" />
                                                   <asp:TextBox ID="txtTenToa" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                    <asp:HiddenField ID="hddToaChuyenID" runat="server" Value="0" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Trạng thái</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbTrangthai" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbTrangthai_SelectedIndexChanged">
                                                        <asp:ListItem Value="0" Text="Chưa chuyển" Selected="True"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã chuyển"></asp:ListItem>
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
                                <asp:Button ID="cmdNhanan" runat="server" CssClass="buttoninput" Text="Chuyển án" OnClick="cmdNhanan_Click" />
                                <asp:Button ID="cmdHuyChuyen" runat="server" CssClass="buttoninput" Text="Hủy chuyển án" OnClientClick="return confirm('Bạn thực sự muốn hủy chuyển án này? ');" OnClick="cmdHuyChuyen_Click" />
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound" OnItemCommand="dgList_ItemCommand">
                                    <Columns>
                                        <asp:BoundColumn DataField="v_VUANID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_MAVUAN" Visible="false" HeaderText="Mã vụ việc"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Chọn</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("v_VUANID")%>' OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="v_TENVUAN" HeaderText="Tên vụ việc" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="62px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Ngày thụ lý</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Literal ID="lstNgaythuly" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Quyết định/ Bản án</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Literal ID="lstSoQDBA" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:BoundColumn DataField="v_TOANHAN" HeaderText="Tòa nhận" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                            <HeaderTemplate>Nội dung</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Literal ID="lstNoiDung" runat="server"></asp:Literal>
                                                <asp:HiddenField ID="hddLydo" runat="server" Value='<%#Eval("v_LYDOID")%>' />
                                                <asp:HiddenField ID="hddTHGiaoNhan" runat="server" Value="" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="v_NGAYCHUYEN" HeaderText="Ngày chuyển" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="v_NGAYNHAN" HeaderText="Ngày nhận" HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="85px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>Thao tác</HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtHuyChuyen" runat="server" ForeColor="#0e7eee" CausesValidation="false" Text="Hủy chuyển án"
                                                    CommandName="HuyChuyen" CommandArgument='<%#Eval("v_VUANID") %>'
                                                    OnClientClick="return confirm('Bạn thực sự muốn hủy chuyển án này? ');"></asp:LinkButton>
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
      <asp:Repeater ID="rptCapNhat" runat="server" OnItemDataBound="rptCapNhat_ItemDataBound">
            <ItemTemplate>
                <asp:HiddenField ID="hddVuViecID" runat="server" Value='<%# Eval("VuViecID") %>' />

                <div class="box_nd">
                    <div class="truong">
                        <div class="boxchung">
                            <h4 class="tleboxchung">Chuyển án</h4>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">

                                    <tr>
                                        <td style="width: 121px;">Mã vụ việc</td>
                                        <td style="width: 210px;">
                                            <asp:HiddenField ID="hddMaVuViec" runat="server" Value='<%# Eval("MaVuVien") %>' />
                                            <asp:TextBox ID="txtN_Mavuviec" CssClass="user" runat="server" Width="90%" ReadOnly="true" Value='<%# Eval("MaVuVien") %>'></asp:TextBox>
                                        </td>
                                        <td style="width: 95px;">Tên vụ việc</td>
                                        <td>
                                            <asp:TextBox ID="txtN_Tenvuviec" CssClass="user" runat="server" Width="100%" ReadOnly="true" Text='<%# Eval("TenVuVien") %>'></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ngày giao<span class="must_input">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtN_Ngaygiao" CssClass="user" onkeypress="return isNumber(event)" runat="server" Width="90%" Text='<%# Eval("NgayGiao") %>'></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtN_Ngaygiao" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtN_Ngaygiao" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <%-- <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtN_Ngaygiao" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>--%>


                                        </td>
                                        <td>Tên tòa án giao</td>
                                        <td>
                                            <asp:TextBox ID="txtN_Toagiao" Text='<%# Eval("ToaGiao") %>' CssClass="user" runat="server" Width="100%" ReadOnly="true"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Trường hợp giao nhận</td>
                                        <td>
                                            <asp:HiddenField ID="hddTHGN" runat="server" Value='<%# Eval("LyDoId") %>' />
                                            <asp:TextBox ID="txtN_THGN" CssClass="user" runat="server" Width="90%" ReadOnly="true" Text='<%# Eval("TruongHopGiaoNhan") %>'></asp:TextBox>
                                        </td>
                                        <td>Tòa án nhận</td>
                                        <td>
                                            <asp:HiddenField ID="hddTN_ID" Value='<%# Eval("ToaAn_ID") %>' runat="server" />
                                            <asp:HiddenField ID="isEnableToaAnTen" Value='<%# Eval("isEnableToaAnTen") %>' runat="server" />

                                            <%--  <asp:TextBox ID="txtTN_Ten" CssClass="txtTN_Ten user" runat="server" Width="100%" MaxLength="250" Text='<%# Eval("ToaAn_Ten") %>'></asp:TextBox>--%>
                                            <asp:DropDownList ID="txtTN_Ten" CssClass="chosen-select" runat="server" Width="100%">
                                                <asp:ListItem Value="0" Selected="True">Tất cả</asp:ListItem>
                                            </asp:DropDownList>

                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" ErrorMessage="*" Text="*" InitialValue="none" ControlToValidate="txtTN_Ten" ValidationGroup="ValidationButton"></asp:RequiredFieldValidator>
                                            <asp:Label runat="server" ID="lbthongbaoCA" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtTN_ghichu" CssClass="user" runat="server" Width="100%" Text='<%# Eval("GhiChu") %>'></asp:TextBox>
                                        </td>
                                    </tr>
                                    
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </ItemTemplate>

        </asp:Repeater>
        <div class="row_center">
            <table class="table1">
                <tr>
                    <td colspan="4">
                        <asp:Label runat="server" ID="lbthongbaoNA" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="4">
                        <asp:Button ID="cmdCapnhat" runat="server" CssClass="buttoninput"
                            OnClientClick="return validate();"
                            Text="Chuyển án" OnClick="cmdLuu_Click" />
                        <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                    </td>
                </tr>
            </table>

        </div>

    </asp:Panel>
    <script src="../../../UI/js/Common.js"></script>
    <script type="text/javascript">
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function validate() {
          <%--  var txtN_Ngaygiao = document.getElementById('<%=txtNgaygiao.ClientID%>');
            if (!Common_CheckEmpty(txtN_Ngaygiao.value)) {
                alert('Bạn chưa nhập ngày giao. Hãy kiểm tra lại!');
                txtN_Ngaygiao.focus();
                return false;
            }--%>

            return true;
        }

    </script>
    <script>
        function pageLoad(sender, args) {
           <%-- $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';
                $("[id$=txtToaAnNhan]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAnNhan]").val(i.item.val); }, minLength: 1
                });
                $("[id$=txtTN_Ten]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddTN_ID]").val(i.item.val); }, minLength: 1
                });
            });--%>
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>