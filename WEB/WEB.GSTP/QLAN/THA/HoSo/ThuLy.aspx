<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThuLy.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.ThuLy" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddBiAnID" Value="0" runat="server" />
    <asp:HiddenField ID="hddVuAnID" Value="0" runat="server" />

    <style>
        .boxchung {
            float: left;
            width: 99%;
            margin-left: 0;
            margin-bottom: 10px;
        }

        .no-tha-row { margin-bottom: 4px; }
        .no-tha-value, .no-tha-reason { word-break: break-word; }
    </style>

    <div class="box">
        <div class="box_nd">
            <asp:Panel ID="pn" runat="server">
                <div class="boxchung">
                    <h4 class="tleboxchung">Thông tin thụ lý</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 75px;">Mã thụ lý</td>
                                <td style="width: 200px;">
                                    <asp:TextBox ID="txtMaThuLy"
                                        CssClass="user" runat="server" Width="170px" placeholder="(Mã sinh tự động)"></asp:TextBox>
                                </td>
                                <td style="width: 100px;">Bị án</td>
                                <td>
                                    <asp:DropDownList ID="dropBiAn" CssClass="chosen-select"
                                        runat="server" Width="277px">
                                    </asp:DropDownList></td>
                            </tr>

                            <tr>
                                <td style="width: 75px;">Mã bị án</td>
                                <td style="width: 200px;">
                                    <asp:TextBox ID="txtMaBiAn"
                                        CssClass="user" runat="server" Width="170px" placeholder="(Mã sinh tự động)"></asp:TextBox>
                                </td>
                              
                            </tr>

                            <tr>
                                <td>Địa chỉ</td>
                                <td>
                                    <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="170px"></asp:TextBox>
                                </td>
                                <td>Trường hợp thụ lý</td>
                                <td>
                                    <asp:DropDownList ID="dropTruongHopThuLy"
                                        CssClass="chosen-select" runat="server" Width="277px">
                                        <asp:ListItem Value="1" Text="Khiếu kiện"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày bản án có hiệu lực</td>
                                <td>
                                    <asp:TextBox ID="txtNgayBanAnCoHieuLuc" CssClass="user align_right"
                                       runat="server" Width="170px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayBanAnCoHieuLuc" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayBanAnCoHieuLuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Số thụ lý <asp:Literal ID="ltSoThuLy" runat="server"></asp:Literal></td>
                                <td>
                                    <div style="float: left">
                                        <asp:TextBox ID="txtSoThuly" CssClass="user align_right" runat="server"
                                            Width="90px"></asp:TextBox>
                                    </div>
                                    <div style="float: left; margin-left: 3px; margin-right: 3px; line-height: 20px;">Ngày thụ lý <asp:Literal ID="ltNgayThuLy" runat="server"></asp:Literal></div>
                                    <asp:TextBox ID="txtNgaythuly" runat="server" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td>Từ ngày<asp:Literal ID="ltTuNgay" runat="server"></asp:Literal></td>
                                <td>
                                    <div style="">
                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user align_right" Width="170px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </div>
                                <td>Đến ngày<asp:Literal ID="ltDenNgay" runat="server"></asp:Literal></td>
                                <td>
                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="170px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>Ghi chú</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtGhichu" CssClass="user" runat="server" Width="590px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>File đính kèm</td>
                                <td>
                                    <asp:HiddenField ID="hddFilePath" runat="server" Value="" />
                                    <cc1:AsyncFileUpload ID="AsyncFileUpLoad" CssClass="floatF" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                        ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF"/>
                                    <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" />
                                    <asp:LinkButton ID="lbtAddFile" CssClass="linkAddFile" Visible="false" runat="server" Text="Thêm file đính kèm"></asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3" style="vertical-align: middle;">
                                    <span>Bị án không phải thi hành án</span>
                                    <asp:CheckBox ID="cb_uttp" runat="server" AutoPostBack="true" OnCheckedChanged="Unnamed_CheckedChanged" />
                                </td>
                            </tr>
                            <asp:PlaceHolder runat="server" ID="khongThiHanhAn" visible="false">
                                <tr>
                                    <td>Ngày thống kê<span class="batbuoc">(*)</span></td>
                                    <td>
                                        <asp:TextBox ID="txtNgayThongKe" CssClass="user align_right"
                                           runat="server" Width="170px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayThongKe" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayThongKe" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Lí do<span class="batbuoc">(*)</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtLiDo" CssClass="user" runat="server" Width="590px"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:PlaceHolder>
                            <tr>
                                <td colspan="2"></td>
                                <td colspan="2">
                                    <asp:Button ID="cmdUpdate" runat="server"
                                        CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </asp:Panel>

            <div style="width: 100%; float: left;">
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>
            <%-- Danh sach hien thi--%>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td>
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                            </div>

                            <asp:Panel runat="server" ID="pndata" Visible="false">
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
                                        
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Trường hợp thụ lý
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TRUONGHOPTHULY") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="220px">
                                            <HeaderTemplate>
                                                Thông tin không THA
                                            </HeaderTemplate>
                                           <ItemTemplate>
                                                    <span><%#Eval("NGAYTHONGKE", "{0:dd/MM/yyyy}") %></span>
                                                        <asp:TextBox ID="txtLyDo" runat="server"
                                                                     Text='<%#Eval("LIDO") %>'
                                                                     TextMode="MultiLine"
                                                                     Rows="2"
                                                                     Width="95%"
                                                                     CssClass="user"
                                                                     ReadOnly="true"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="65px">
                                            <HeaderTemplate>File đính kèm</HeaderTemplate>
                                            <ItemTemplate >
                                                <asp:ImageButton ID="lblDownload" ImageUrl="~/UI/img/ghim.png" runat="server" CausesValidation="false" CommandName="Download"
                                                    CommandArgument='<%#Eval("ID") %>' ToolTip='<%#Eval("FILE_ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
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
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
            <%-- End danh sach hien thi --%>

        </div>
        
    </div>
    <div style="margin-top: 200px"></div>

    <script type="text/javascript">
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
        function validate() {
            var NgaySoSanh = '<%= NgaySoSanh%>';

            var txtSoThuly = document.getElementById('<%=txtSoThuly.ClientID%>');
            if (!Common_CheckTextBox(txtSoThuly, "Số thụ lý"))
                return false;
            //-------------------------------------
            var txtNgaythuly = document.getElementById('<%=txtNgaythuly.ClientID%>');
            var txtNgayBanAnCoHieuLuc = document.getElementById('<%=txtNgayBanAnCoHieuLuc.ClientID%>');
            if (!CheckDateTimeControl(txtNgaythuly, 'Ngày thụ lý'))
                return false;
            if (txtNgayBanAnCoHieuLuc != "") {
                if (!SoSanh2Date(txtNgaythuly, 'Ngày thụ lý', txtNgayBanAnCoHieuLuc.value, 'Ngày bản án có hiệu lực'))
                    return false;
            }
            //-------------------------------------
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            if (Common_CheckEmpty(txtTuNgay.value)) {
                if (!Common_IsTrueDate(txtTuNgay.value)) {
                    txtDenNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
             if (Common_CheckEmpty(txtDenNgay.value)) {
                 if (!Common_IsTrueDate(txtDenNgay.value)) {
                     txtDenNgay.focus();
                     return false;
                 }
                 //------------------------
                 if (!SoSanh2Date(txtDenNgay, 'Mục "Đến ngày"', txtTuNgay.value, 'mục "Từ ngày"', )) {
                     txtDenNgay.focus();
                     return false;
                 }
            }

            var txtNgayThongKe = document.getElementById('<%=txtNgayThongKe.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThongKe, 'Ngày thống kê'))
                return false;

            var txtLiDo = document.getElementById('<%=txtLiDo.ClientID%>');
            if (!Common_CheckTextBox(txtLiDo, "Lí do không thi hành án"))
                return false;
            return true;
        }
    </script>
</asp:Content>
