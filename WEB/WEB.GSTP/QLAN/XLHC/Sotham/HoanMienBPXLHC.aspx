<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="HoanMienBPXLHC.aspx.cs" Inherits="WEB.GSTP.QLAN.XLHC.Sotham.HoanMienBPXLHC" %>

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
            width: 120px;
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
    <div id="divBackground" style="position: absolute; top: 0px; left: 0px; background-color: black; z-index: 100; opacity: 0.8; filter: alpha(opacity=60); -moz-opacity: 0.8; overflow: hidden; display: none">
    </div>

    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin đơn đề nghị</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>Loại đơn</td>
                            <td colspan="3">
                                <asp:DropDownList ID="dropBienPhapGQ" CssClass="chosen-select" Width="468px" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="width: 105px;">Ngày nhận đơn<span class="must_input">(*)</span></td>
                            <td style="width: 262px;">
                                <asp:TextBox ID="txtNgaynhan" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgaynhan_CalendarExtender" runat="server" TargetControlID="txtNgaynhan" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaynhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 80px;">Ngày viết đơn</td>
                            <td style="width: 120px;">
                                <asp:TextBox ID="txtNgayviet" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtNgayviet_CalendarExtender" runat="server" TargetControlID="txtNgayviet" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayviet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblNguoiDungDon" runat="server" Text="Người đứng đơn"></asp:Label><span class="must_input">(*)</span>
                            </td>
                            <td colspan="3">
                                <asp:TextBox ID="txtNguoiDungDon" CssClass="user" runat="server" Width="460px"></asp:TextBox>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblLydo" runat="server" Text="Lý do"></asp:Label><span class="must_input">(*)</span></td>
                            <td colspan="3">
                                <asp:TextBox ID="txtLyDo" CssClass="user" runat="server" Width="460px" TextMode="MultiLine" Rows="5"></asp:TextBox>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>File đính kèm</td>
                            <td>
                                <asp:HiddenField ID="hddFilePath_KC" runat="server" />
                                <cc1:AsyncFileUpload ID="AsyncFileUpLoadHoanMien" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoadHoanMien_UploadedComplete"
                                    ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" />
                            </td>
                            <td colspan="2">
                                <asp:LinkButton ID="lbtDownloadHoanMien" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownloadHoanMien_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div id="divKetQuaGiaiQuyet" class="boxchung" runat="server" visible="False">
                <h4 class="tleboxchung">Kết quả giải quyết</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 105px;">Giải quyết đơn?</td>
                            <td colspan="3">
                                <asp:RadioButtonList ID="rdbIsGiaiquyet" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbIsGiaiquyet_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Selected="True">Chưa giải quyết</asp:ListItem>
                                    <asp:ListItem Value="1">Đã giải quyết</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>

                        </tr>
                        <tr>
                            <td style="width: 105px;">Ngày giải quyết<span class="must_input">(*)</span></td>
                            <td style="width: 120px;">
                                <asp:TextBox ID="txtNgayGQ" runat="server" CssClass="user" Width="100px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayGQ" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayGQ" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td style="width: 80px;">Người ký</td>
                            <td>
                                <asp:DropDownList ID="ddlNguoiky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td>Kết quả</td>
                            <td colspan="3">
                                <asp:RadioButtonList ID="rdbKetqua" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="0">Không chấp nhận đề nghị</asp:ListItem>
                                    <asp:ListItem Value="1">Chấp nhận đề nghị</asp:ListItem>
                                </asp:RadioButtonList></td>
                        </tr>
                        <tr>
                            <td>Vụ việc quá hạn luật định ?</td>
                            <td colspan="3">
                                <asp:RadioButtonList ID="rdVuAnQuaHan" AutoPostBack="true"
                                    runat="server" RepeatDirection="Horizontal"
                                    OnSelectedIndexChanged="rdVuAnQuaHan_SelectedIndexChanged">
                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <asp:Panel ID="pnNguyenNhanQuaHan" runat="server" Visible="false">
                            <tr>
                                <td>Nguyên nhân chủ quan</td>
                                <td>
                                    <asp:RadioButtonList ID="rdNNChuQuan" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td>Nguyên nhân khách quan
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="rdNNKhachQuan" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="0">Không</asp:ListItem>
                                        <asp:ListItem Value="1">Có</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </asp:Panel>
                    </table>
                </div>
            </div>
        
            <div>
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div style="text-align: center;">
                                <asp:Button ID="cmdCapNhat" runat="server"
                                            CssClass="buttoninput" Text="Lưu" OnClick="cmdCapNhat_Click" OnClientClick=" return Validate();" />
                                <asp:Button ID="cmdThemmoi" runat="server" CssClass="buttoninput" Text="Làm mới"
                                            OnClick="btnThemmoi_Click" />
                                <asp:Button ID="cmdLoad" runat="server" Style="display: none;" disable="false"
                                            OnClick="cmdLoad_Click" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField ID="hddCurrID" runat="server" />
                            <div class="phantrang" Style="display: none;">
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
                                                    <div align="center">TT</div>
                                                </td>
                                                <td width="300px">
                                                    <div align="center">Loại đơn đề nghị</div>
                                                </td>
                                                <td width="100px">
                                                    <div align="center">Người đứng đơn</div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center">Số, Ngày thụ lý xem xét</div>
                                                </td>
                                                <td width="100px">
                                                    <div align="center">Thẩm phán xem xét</div>
                                                </td>
                                                <td width="300px">
                                                    <div align="center">Kết quả giải quyết</div>
                                                </td>
                                                <td width="80px">
                                                    <div align="center">Nguời tạo</></div>
                                                </td>
                                                <td width="80px">
                                                    <div align="center">Ngày tạo</div>
                                                </td>
                                                <td width="120px">
                                                    <div align="center">Thao tác</div>
                                                </td>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("STT") %></td>
                                            <td><%# Eval("TENLOAIDON") %></td>
                                            <td><%# Eval("NGUOI_DUNG_DON") %></td>
                                            <td><%# Eval("TT_THULY")  %></td>
                                            <td><%# Eval("TENTHAMPHAN") %></td>
                                            <td><%# Eval("TENGIAIQUYET") %></td>
                                            <td><%# Eval("NguoiTao") %></td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                            <td>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa"
                                                    OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                                <asp:LinkButton ID="lbtGiaiQuyet" runat="server" CausesValidation="false" Text="Giải quyết" ForeColor="#0e7eee" CommandName="GiaiQuyet"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip="Giải quyết"></asp:LinkButton>
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
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }

        }

        function LoadModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            var parentHeight = document.getElementById("divTreeMenuLeft");

            bcgDiv.style.display = "block";
            if (bcgDiv != null) {

                if (document.body.clientHeight > document.body.scrollHeight) {

                    bcgDiv.style.height = document.body.clientHeight + "px";
                }
                else {

                    bcgDiv.style.height = document.body.scrollHeight + "px";
                }
                bcgDiv.style.width = "100%";
                bcgDiv.style.height = parentHeight.clientHeight + 250 + "px";
            }
        }

        function HideModalDiv() {
            var bcgDiv = document.getElementById("divBackground");
            bcgDiv.style.display = "none";
            $("#<%= cmdLoad.ClientID %>").click();
        }
    </script>
</asp:Content>
