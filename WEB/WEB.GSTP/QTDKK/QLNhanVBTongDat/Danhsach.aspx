<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTDKK.QLNhanVBTongDat.Danhsach" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

    <style>
        .table2 tr, td {
            vertical-align: top;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <table class="table1" style="margin: 15px 0px 0px 0px;">
                <tr>
                    <td style="width: 90px;">Vụ việc, mã vụ việc</td>
                    <td style="width:469px">
                        <asp:TextBox ID="txtVuViec" CssClass="user" runat="server"
                            Width="497px" placeholder="Nhập tên vụ việc, mã vụ việc"></asp:TextBox></td>

                    <td style="width: 93px;">Quan hệ pháp luật</td>
                    <td>
                        <asp:TextBox ID="txtQuanHePhapLuat" CssClass="user" runat="server"
                            Width="200px" placeholder="Nhập quan hệ pháp luật"></asp:TextBox></td>
                </tr>
                
            </table>


            <table class="table1" style="margin: 0px 0px;">
                <tr>
                    <td>Mã đăng ký</td>
                    <td style="width:193px">
                        <asp:TextBox ID="txtMaDangKy" runat="server" CssClass="user" Width="193px"></asp:TextBox></td>
                    
                    <td style="width:70px">Trạng thái</td>
                    <td style="width:203px">
                        <asp:DropDownList CssClass="user" ID="dropTrangThai" runat="server" Width="200px">
                        </asp:DropDownList></td>
                    <td style="width: 90px;">Tư cách tố tụng</td>
                    <td>
                        <asp:DropDownList CssClass="user" ID="dropTucachToTung" runat="server" Width="209px">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    
                    <td style="width: 90px;">CMND/ Thẻ căn cước/ Hộ chiếu</td>
                    <td>
                        <asp:TextBox ID="txtCMND" runat="server" CssClass="user" Width="193px"></asp:TextBox></td>
                    <td style="width: 90px;">Số điện thoại</td>
                    <td>
                        <asp:TextBox ID="txtSoDienThoai" CssClass="user" runat="server"
                            Width="192px" placeholder="Nhập số điện thoại"></asp:TextBox></td>
                    <td style="width: 90px;">Email</td>
                    <td>
                        <asp:TextBox ID="txtEmail" CssClass="user" runat="server"
                            Width="200px" placeholder="Nhập email"></asp:TextBox></td>
                </tr>
                 <tr>
                    <td>Tên đương sự</td>
                    <td >
                        <asp:TextBox ID="txtTenDuongSu" runat="server" CssClass="user" Width="193px"></asp:TextBox></td>
                     
                    <td>Từ ngày</td>
                    <td>
                        <asp:TextBox ID="txtTuNgay" runat="server"
                            CssClass="user" placeholder="..../..../...."
                            Width="192px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                    </td>
                    <td>Đến ngày</td>
                    <td>
                        <asp:TextBox ID="txtDenNgay" runat="server"
                            CssClass="user" placeholder="..../..../...."
                            Width="200px" MaxLength="10"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server"
                            TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date"
                            CultureName="vi-VN" ErrorTooltipEnabled="true" />
                        
                    </td>
                </tr>
                
                <tr>
                    <td colspan="4">
                        <asp:Literal ID="lttMsg" runat="server"></asp:Literal></td>
                </tr>
            </table>
            <div style="text-align:center">
                <asp:Button ID="cmdSearch" runat="server" CssClass="buttoninput" Text="Tìm kiếm"
                            OnClick="cmdSearch_Click" />
                <asp:Button ID="btnIn" runat="server" CssClass="buttoninput" Text="In"
                            OnClick="cmdIn_Click" />
            </div>
            <div style="width: 98%; float: left;">
                <asp:Panel runat="server" ID="pnPagingTop" Visible="false">
                    <div class="phantrang" style="margin-bottom: 8px;">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click" Text="|<"></asp:LinkButton>
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
                                OnClick="lbTNext_Click" Text=">|"></asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>
                <div class="CSSTableGenerator">
                    <table class="table2" style="width: 100%" border="1">
                        <tr class="header">
                            <td style="width: 30px;"></td>
                            <td style="width: 30px;">TT</td>
                            <td style="width: 150px">Tòa án thụ lý</td>
                            <td style="width: 150px">Người yêu cầu</td>

                             <td style="width: 70px">Mã đăng ký</td>
                            <td>Vụ việc</td>
                            <td style="width: 80px;">Ngày ĐK</td>
                            <td style="width: 95px;">Tình trạng</td>
                            <td style="width: 50px;">Thao tác</td>
                        </tr>
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                            <ItemTemplate>
                                <tr>
                                    <td style="text-align:center"><asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' AutoPostBack="true" runat="server" /></td>
                                    <td><%#Eval("STT") %></td>
                                    <td><%#Eval("TENTOAAN") %></td>
                                    <td><b style="margin-right: 5px;">Họ tên:</b><%#Eval("TenDuongSu") %><br />
                                        <b style="margin-right: 5px;">CMND:</b><%#Eval("CMND") %>
                                    </td>
                                    <td><%#Eval("MaDangKy") %></td>
                                    <td style='line-height: 20px'>
                                        <b style="margin-right: 5px;">Mã vụ việc:</b><%#Eval("MaVuViec") %><br />
                                        <b style="margin-right: 5px;">Tư cách tố tụng:</b><%#Eval("TenTuCachToTung") %><br />
                                        <b style="margin-right: 5px;">Vụ việc:</b><%#Eval("TenVuViec") %>
                                    </td>
                                    <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                                    <td><%#Eval("TrangThaiDuyet") %></td>
                                    <td>
                                        <div style="text-align: center;">
                                            <%--<div class="tooltip">
                                                <asp:ImageButton ID="cmdLock" runat="server" CssClass="grid_button"
                                                    OnClientClick="return confirm('Bạn thực sự muốn ngừng giao dịch điện tử cho mục đã đăng ký này? ');"
                                                    CommandName="Lock" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/lock.png" Width="20px" />

                                                <span class="tooltiptext  tooltip-bottom">Khóa giao dịch điện tử</span>
                                            </div>
                                            <div class="tooltip">
                                                <asp:ImageButton ID="cmdActive" runat="server"
                                                    CssClass="grid_button"
                                                    CommandName="Active" CommandArgument='<%#Eval("ID") %>'
                                                    ImageUrl="~/UI/img/unlock.png" Width="20px" />
                                                <span class="tooltiptext  tooltip-bottom">Duyệt đăng ký</span>
                                            </div>--%>
                                            <asp:LinkButton ID="lbtDuyet" Text="Duyệt" runat="server" CssClass="grid_button"
                                                    OnClientClick="return confirm('Bạn có muốn duyệt văn bản đăng ký này !');"
                                                    CommandName="lbtDuyet" CommandArgument='<%#Eval("ID") %>'/>
                                            <asp:LinkButton ID="lbtMo" Text="Mở" runat="server" CssClass="grid_button"
                                                    OnClientClick="return confirm('Bạn có muốn mở văn bản đăng ký này !');"
                                                    CommandName="lbtMo" CommandArgument='<%#Eval("ID") %>'/>

                                            <asp:LinkButton ID="lbtDong" Text="Đóng" runat="server" CssClass="grid_button"
                                                   
                                                    CommandName="lbtDong" CommandArgument='<%#Eval("ID") %>'/>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                </div>
                <asp:Panel runat="server" ID="pnPagingBottom" Visible="false">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:HiddenField ID="hdicha" runat="server" />
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click" Text="|<"></asp:LinkButton>
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
                                OnClick="lbTNext_Click" Text=">|"></asp:LinkButton>
                        </div>
                    </div>

                </asp:Panel>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13) {
                    $("#<%= cmdSearch.ClientID %>").click();
                }
            });
        });
        function change_control() {
            $("#<%= cmdSearch.ClientID %>").click();
        }

        
    </script>
    <script>
        function popup_LyDoVbTongDat(Id) {
            var link = "/QTDKK/QLNhanVBTongDat/pLyDoVBTongDat.aspx?Id=" + Id;
            var width = 850;
            var height = 400;
            var left = (screen.width / 2) - (width / 2);
            var top = (screen.height / 2) - (height/ 2);
            window.open(link, '', 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + width + ', height=' + height + ', top=' + top + ', left=' + left);
        };

        function ReLoadGrid() {
            $("#<%= cmdSearch.ClientID %>").click();
        }
    </script>
    <%--  <script>
        function pageLoad(sender, args) {           

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>--%>
</asp:Content>
