<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="DsDangKyNhanVBTongDat.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.DsDangKyNhanVBTongDat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .table_detail tr, td {
            padding-left: 0px;
        }
        .tooltip a{
            text-decoration:underline;
            color: #0982ff;
        }
    </style>
    <div class="thongtin_lienhe">
        <div class="dangky_head border_radius_top">
            <div class="dangky_head_title">Danh sách đăng ký nhận văn bản, thông báo của Tòa án</div>
            <div class="dangky_head_right"></div>
        </div>
        <div class="dangky_content">
            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
            <table style="width: 100%; margin-top: 5px; float: left;">
                <tr>
                    <td style="width: 110px;">Vụ việc, mã vụ việc, mã đăng ký</td>
                    <td style="width: 220px;">
                        <asp:TextBox ID="txtVuViec" CssClass="textbox" runat="server"
                            Width="250px" placeholder="Nhập tên vụ việc, mã vụ việc, mã đăng ký"></asp:TextBox></td>
                    <td  style="width: 50px;padding-left: 65px;">Tòa án</td>
                    <td>
                        <asp:HiddenField ID="hddToaAnID" runat="server" />
                        <asp:TextBox ID="txtToaAn" runat="server"
                            placeholder="(Gõ tên Tòa án vào đây để tìm kiếm)"
                            CssClass="textbox" Width="96%" AutoCompleteType="Search"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Tư cách tố tụng</td>
                    <td>
                        <asp:DropDownList ID="ddlTuCachToTung"
                            CssClass="dropbox" runat="server" Width="264px" Height="32px">
                            <asp:ListItem Value="" Text="----Chọn----"></asp:ListItem>
                           <%-- <asp:ListItem Value="0" Text="Chưa duyệt"></asp:ListItem>--%>
                            <asp:ListItem Value="NGUYENDON" Text="Nguyên đơn/Người khởi kiện"></asp:ListItem>
                            <asp:ListItem Value="BIDON" Text="Bị đơn/Người bị kiện"></asp:ListItem>
                            <asp:ListItem Value="QUYENNVLQ" Text="Người có quyền và NVLQ"></asp:ListItem>
                        </asp:DropDownList>
                        <%--<asp:TextBox ID="txtTuCachTT" CssClass="textbox" runat="server"
                            Width="200px" placeholder="Nhập tư cách tố tụng"></asp:TextBox></td>--%>
                    </td>
                    <td style="width: 50px;padding-left: 65px;">Họ tên</td>
                    <td>
                        <asp:TextBox ID="txtHoten" CssClass="textbox" runat="server"
                            Width="96%" placeholder="Nhập họ tên"></asp:TextBox>

                    </td>
                </tr>
                <tr>
                    <td>Trạng thái</td>
                    <td>
                        <asp:DropDownList ID="dropTrangThai"
                            CssClass="dropbox" runat="server" Width="264px" Height="32px">
                            <asp:ListItem Value="4" Text="----Chọn----"></asp:ListItem>
                            <asp:ListItem Value="0" Text="Chưa duyệt"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Đang giao dịch điện tử"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Ngừng giao dịch điện tử"></asp:ListItem>
                            <asp:ListItem Value="3" Text="Tạm dừng giao dịch điện tử"></asp:ListItem>
                        </asp:DropDownList>
                        
                    </td>
                    <td  style="width: 50px;padding-left: 65px;" colspan="2" ><asp:Button ID="cmdSearch" runat="server" CssClass="button_search" Text="Tìm kiếm"
                            OnClick="cmdSearch_Click" /></td>
                </tr>
                
                <tr style="display: none;">
                    <td colspan="4">
                        <asp:Button ID="cmdStop" runat="server" CssClass="button_search stop_icon"
                            Text="Ngừng nhận tất cả văn bản, thông báo"
                            OnClick="cmdStop_Click" />
                        <a href="/Personnal/DangKyNhanVB.aspx" class="link_new right">Đăng ký nhận VB/ TB mới</a>
                    </td>
                </tr>

                <tr>
                    <td colspan="4">
                        <div style="float: left; width: 100%;">
                            <asp:Literal ID="lttMsg" runat="server"></asp:Literal>
                        </div>
                        <asp:Panel runat="server" ID="pnPagingTop" Visible="false">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click" Text="<"></asp:LinkButton>
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
                                        OnClick="lbTNext_Click" Text=">"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </asp:Panel>
                        <div class="CSSTableGenerator">
                            <table>
                                <tr id="row_header">
                                    <td style="width: 20px;">TT</td>
                                    <td style="width: 150px">Tòa án thụ lý</td>
                                    <td>Vụ việc</td>
                                    <td style="width: 70px;">Ngày ĐK</td>
                                    <%--<td style="width: 50px;">Mã ĐK</td>--%>
                                    <td style="width: 70px;">Tình trạng</td>

                                    <td style="width: 155px;">Thao tác</td>
                                </tr>
                                <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%#Eval("STT") %>
                                                <asp:HiddenField ID="hddID" Value='<%#Eval("GroupDK") %>' runat="server" />
                                            </td>
                                            <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                <%#Eval("TENTOAAN") %></a></td>
                                            <td style='line-height: 20px'>
                                                <a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                    <b style="margin-right: 5px;">Mã vụ việc:</b><%#Eval("MaVuViec") %><br />
                                                    <b style="margin-right: 5px;">Tư cách tố tụng:</b><%#Eval("TenTuCachToTung") %><br />
                                                    <b style="margin-right: 5px;">Vụ việc:</b><%#Eval("TenVuViec") %></a></td>
                                            <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                <%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></a>
                                            </td>
                                            <%--<td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                <%#Eval("MaDangKy") %></a></td>--%>
                                            <td><a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                <%#Eval("TrangThaiDuyet") %></a></td>
                                            <td>
                                                <div style="text-align: center;">
                                                    <div class="tooltip">
                                                        <a href='/Personnal/ChiTietDKNhanVB.aspx?group=<%#Eval("GroupDK") %>'>
                                                            <%--<img src='/UI/img/view.png' alt='Xem' style="width: 17px;" />--%>
                                                            Xem chi tiết đăng ký
                                                        </a>
                                                        <span class="tooltiptext  tooltip-bottom">Xem chi tiết đăng ký</span>
                                                    </div>
                                                    <%--<div class="tooltip">
                                                        <asp:LinkButton ID="cmdLock" runat="server" ToolTip="Khóa" CssClass="grid_button"
                                                            OnClientClick="return confirm('Bạn thực sự muốn ngừng giao dịch điện tử cho vụ việc này?Nếu chọn ngừng giao dịch điện tử thì kể từ lúc xác nhận đồng ý, bạn sẽ không nhận được các văn bản/ thông báo từ Tòa án qua phương thức trực tuyến.');"
                                                            CommandName="Khoa" CommandArgument='<%#Eval("ID") %>'
                                                            Text="Ngừng giao dịch điện tử"/>
                                                        ~/UI/img/unlock.png
                                                        <span class="tooltiptext  tooltip-bottom">Ngừng giao dịch điện tử</span>
                                                    </div>--%>
                                                    <div class="tooltip">

                                                        <asp:LinkButton ID="cmdUnlock" runat="server" ToolTip="Kích hoạt" CssClass="grid_button"
                                                            OnClientClick="return showthongbao();"
                                                            Text="Kích hoạt giao dịch điện tử" />
                                                        <%--~/UI/img/unlock.png--%>
                                                        <span class="tooltiptext  tooltip-bottom">Kích hoạt giao dịch điện tử</span>
                                                    </div>

                                                    <%--<div class="tooltip">
                                                        <asp:LinkButton ID="lbtDangKi" runat="server" ToolTip="Đăng ký" CssClass="grid_button" Text="Đăng ký" CommandName="DangKi" CommandArgument='<%#Eval("ID") %>' /> 
                                                        ~/UI/img/unlock.png
                                                        <span class="tooltiptext  tooltip-bottom">Đăng ký</span>
                                                    </div>--%>
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
                                        OnClick="lbTBack_Click" Text="<"></asp:LinkButton>
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
                                        OnClick="lbTNext_Click" Text=">"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="dangky_tk_dropbox"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        </asp:Panel>
                    </td>
                </tr>
            </table>

        </div>
    </div>
    <script type="text/javascript">
        function showthongbao() {
            alert('Vụ việc đã ngừng giao dịch điện tử, để tiếp tục sử dụng bạn cần thực hiện lại việc đăng ký nhận văn bản/ thông báo qua hình thức trực tuyến!');
            return false;
        }
        $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13)
                    $("#<%= cmdSearch.ClientID %>").click();
            });
        });
    </script>
    <script>
        function pageLoad(sender, args) {
            $(function () {
                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetAllToaTraVBTongDatOnline") %>';
                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) {
                        $("[id$=hddToaAnID]").val(i.item.val);
                        //$("#<%= cmdSearch.ClientID %>").click();
                    }, minLength: 1
                });
            });

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
