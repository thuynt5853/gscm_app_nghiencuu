<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.XuLyDon.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 36px;
        }

        .auto-style2 {
            height: 36px;
        }

        .lable_td {
            width: 100px;
        }

        .checkbox {
            width: 100%;
        }

            .checkbox label {
                margin-left: 5px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">

        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Xử lý hồ sơ</h4>
                                  <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="lable_td">Biện pháp GQ/YC</td>
                                            <td style="width: 260px;">
                                                <asp:DropDownList ID="dropBienPhapGQ" CssClass="chosen-select" runat="server"
                                                    Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlBienPhapGQ_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="lable_td">
                                                <asp:Label ID="lblNgayGQ" runat="server" Text="Ngày GQ/YC"></asp:Label><span class="must_input">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtNgayGQ" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayGQ_CalendarExtender" runat="server" TargetControlID="txtNgayGQ" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtNgayGQ" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                            </td>
                                        </tr>
                                        <!---------chọn = chuyen don trong nganh-------->
                                        <asp:Panel ID="pnCDTN" runat="server" Visible="false">
                                            <tr>
                                                <td>Tòa án nhận<span class="must_input">(*)</span></td>
                                                <td colspan="3">
                                                    <asp:HiddenField ID="hddToaAn" runat="server" />
                                                    <a alt="Nhập tên để chọn tòa án" class="tooltipbottom">
                                                        <asp:TextBox ID="txtToaAn" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </a>
                                                </td>

                                            </tr>
                                        </asp:Panel>
                                        <!-----------------Chuyen don ngoai nganh-------------------------->
                                        <asp:Panel ID="pnCDNN" runat="server" Visible="false">
                                            <tr>
                                                <td>CQ/TC nhận đơn<span class="must_input">(*)</span></td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtCDNN_TenCoQuan" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày chuyển</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtCDNN_NgayChuyen" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="txtCDTN_NgayNhan_CalendarExten" runat="server" TargetControlID="txtCDNN_NgayChuyen" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtCDNN_NgayChuyen" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtCDNN_NgayChuyen" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator></td>
                                            </tr>
                                        </asp:Panel>
                                        <!-----------------Tra don -------------------------->
                                        <asp:Panel ID="pnTraDon" runat="server" Visible="false">
                                            <tr>
                                                <td >Lý do<span class="must_input">(*)</span></td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLyTradon" runat="server" CssClass="chosen-select" Width="250px"></asp:DropDownList>
                                                </td>
                                                <td class="lable_td">Ngày trả đơn</td>
                                                <td>
                                                    <asp:TextBox ID="txtTradon_Ngay" runat="server" CssClass="user" Width="150px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTradon_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtTradon_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender5" ControlToValidate="txtTradon_Ngay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                                
                                            </tr>
                                        </asp:Panel>
                                        <!---------------------------------------------->
                                        <asp:Panel ID="pnYCBS" runat="server" Visible="false">
                                            <tr>
                                                <td>Ngày yêu cầu bổ sung</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtNgayYCBS" runat="server" CssClass="user" Width="242px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayYCBS" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayYCBS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                    <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender4" ControlToValidate="txtNgayYCBS" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Yêu cầu bổ sung</td>
                                                <td colspan="3">
                                                    <asp:TextBox ID="txtYCBS" CssClass="user" runat="server" Width="525px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblLydo" runat="server" Text="Lý do"></asp:Label></td>
                                            <td colspan="3">
                                                <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="525px" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                                        </tr>

                                    </table>
                                </div>
                            </div>
                          
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <div class="truong" style="text-align: center;">
                                <asp:Button ID="cmdCapNhat" runat="server"
                                    CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhat_Click" OnClientClick=" return Validate();" />
                                <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Làm mới"
                                    OnClick="btnThemmoi_Click" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField ID="hddCurrID" runat="server" />
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                            <div>
                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                    <HeaderTemplate>
                                        <table class="table2" width="100%" border="1">
                                            <tr class="header">
                                                <td width="42px">
                                                    <div align="center"><strong>TT</strong></div>
                                                </td>
                                                <td>
                                                    <div align="center"><strong>Biện pháp GQ</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Ngày GQ/YC</strong></div>
                                                </td>
                                                <td width="30%">
                                                    <div align="center"><strong>Nơi tiếp nhận</strong></div>
                                                </td>

                                                <td width="10%">
                                                    <div align="center"><strong>Nguời tạo</strong></div>
                                                </td>
                                                <td width="10%">
                                                    <div align="center"><strong>Ngày tạo</strong></div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center"><strong>Thao tác</strong></div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("STT") %></td>
                                            <td><%#Eval("BIENPHAPGQ") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYGQ_YC")) %></td>
                                            <td>
                                                <asp:Literal ID="lttNoiTiepNhan" runat="server"></asp:Literal></td>
                                            <td><%# Eval("NguoiTao") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                           <td align="center">
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </td>
                                             <td style="display: none;">
                                                <asp:HiddenField ID="hddToaGiaiQuyetID" runat="server" Value='<%#Eval("TOA_GIAIQUYET_ID") %>' />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';

                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAn]").val(i.item.val); }, minLength: 1
                });

            });

            //------------------------------------------------
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }
        function Validate() {
            var dropBienPhapGQ = document.getElementById('<%=dropBienPhapGQ.ClientID%>');
            var bienphap = dropBienPhapGQ.options[dropBienPhapGQ.selectedIndex].value;
            var txtNgayGQ = document.getElementById('<%= txtNgayGQ.ClientID%>');

            if (!Common_CheckEmpty(txtNgayGQ.value)) {
                alert('Bạn cần nhập ngày GQ/ YC!');
                txtNgayGQ.focus();
                return false;
            }
            if (bienphap == 1) {

                var hddToaAn = document.getElementById('<%= hddToaAn.ClientID %>');
                var txtToaAn = document.getElementById('<%= txtToaAn.ClientID %>');
                if (hddToaAn.value == '' || hddToaAn.value == "0") {
                    alert('Bạn cần chọn cơ quan tiếp nhận!');
                    txtToaAn.focus();
                    return false;
                }
            } else if (bienphap == 2) {
                var txtCDNN_TenCoQuan = document.getElementById('<%=txtCDNN_TenCoQuan.ClientID%>');
                if (txtCDNN_TenCoQuan.value == "") {
                    alert('Bạn cần nhập tên cơ quan ngoài!');
                    txtCDNN_TenCoQuan.focus();
                    return false;
                }
            }
            return true;
        }

    </script>
</asp:Content>
