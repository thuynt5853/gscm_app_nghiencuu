<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="DsDon.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.DsDon" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .border_search {
            border: 1px solid #b0b0b0;
            border-radius: 4px;
            float: left;
            margin-bottom: 20px;
            margin-top: 20px;
            padding: 10px 3%;
            width: 94%;
        }

        .table1 tr, td {
            padding-left: 0px;
        }
        .trangthaihs{font-weight:bold; width:100%; margin-bottom:5px; text-align:center;float:left;}
        .title_yeucau{font-weight:bold; display:none; }
        .str_yeucau{color:red;font-style:italic;text-align:center;float:left;}
    </style>
    <div class="thongtin_lienhe">
        <div class="dangky_head border_radius_top">
            <div class="dangky_head_title">Danh sách đơn</div>
            <div class="dangky_head_right"></div>
        </div>
        <div class="dangky_content">
            <div class="border_search">
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 60px;">Trạng thái</td>
                        <td style="width: 230px;">
                            <asp:DropDownList ID="dropTrangThai" runat="server" Width="220px"
                                CssClass="dropbox">
                            </asp:DropDownList></td>
                        <td style="width: 105px;">Tòa án giải quyết</td>
                        <td>
                            <asp:HiddenField ID="hddToaAnID" runat="server" />
                            <asp:TextBox ID="txtToaAn" runat="server"
                                placeholder="(Gõ tên Tòa án vào ô trên để tìm kiếm và lựa chọn)"
                                CssClass="textbox" Width="314px" AutoCompleteType="Search"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Mã/ Tên vụ việc</td>
                        <td>
                            <asp:TextBox ID="txtVuViec" runat="server"
                                CssClass="textbox" Width="205px"></asp:TextBox></td>
                        <td>Đương sự</td>
                        <td>
                            <asp:TextBox ID="txtDuongSu" runat="server"
                                CssClass="textbox" Width="314px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>Từ ngày</td>
                        <td>
                            <span style="float: left;">
                                <asp:TextBox ID="txtTuNgay" runat="server"
                                    CssClass="textbox" placeholder="..../..../...."
                                    Width="65px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </span>
                            <span style="margin-right: 3px; margin-left: 3px; float: left; line-height: 28px;">Đến ngày</span>
                            <span style="float: left;">
                                <asp:TextBox ID="txtDenNgay" runat="server"
                                    CssClass="textbox" placeholder="..../..../...."
                                    Width="65px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                            </span></td>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdSearch" runat="server" CssClass="button_search"
                                Text="Tìm kiếm" OnClick="cmdSearch_Click" />
                            <a href="/Personnal/GuiDonKien.aspx" class="link_new">Soạn đơn khởi kiện</a></td>
                    </tr>
                </table>
            </div>
            <div class="msg_thongbao">
                <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
            </div>

            <!-------------------------------------------->
            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
            <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
            <asp:HiddenField ID="hddPageSize" Value="10" runat="server" />
            <asp:Panel ID="pnDS" runat="server">
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
                            <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="20" Text="20" ></asp:ListItem>
                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <asp:Repeater ID="rpt" runat="server"
                    OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                    <HeaderTemplate>
                        <div class="CSSTableGenerator">
                            <table>
                                <tr id="row_header_red">
                                    <td style="width: 20px;">TT </td>
                                    <td>Nội dung</td>
                                    <td style="width: 25%;">Trạng thái đơn</td>
                                    <td style="width: 50px;">Ngày gửi</td>
                                   
                                    <td style="width: 50px;">VB tống đạt</td>
                                    <td style="width: 80px;">Thao tác</td>
                                </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%#Eval("STT") %>
                                <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("VuAnID") %>' />
                                <asp:HiddenField ID="hddDonKKID" runat="server" Value='<%#Eval("ID") %>' />
                                <asp:HiddenField ID="hddTrangthai" runat="server" Value='<%#Eval("Trangthai") %>' />
                            </td>
                            <td> <%# String.IsNullOrEmpty(Eval("MaVuViec")+"")? "": ("- <b>Mã hồ sơ: </b>"+Eval("MaVuViec") +"<br />")%>
                              - <b>Người gửi đơn: </b><%#Eval("TenNguoiGui") %><br />
                                 -  <b>Vụ việc: </b>
                                <asp:Literal ID="lttTenVuViec" runat="server"></asp:Literal>
                                <br /><b>- Nơi nhận đơn: </b><%#Eval("TenToaAn") %>                                
                            </td>
                            <td>
                                <asp:Literal ID="lttTrangThai" runat="server"></asp:Literal></td>
                            <td><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayTao")) %></td>
                          
                            <td style="text-align: center;">
                                <asp:Literal ID="lttCountVB" runat="server"></asp:Literal></td>
                            <td>
                                <div class="align_center">
                                    <div class="tooltip">
                                        <asp:Literal ID="lttEdit" runat="server"></asp:Literal>
                                        <asp:Literal ID="lttTooltip" runat="server"></asp:Literal>
                                    </div>
                                    
                                    <div class="tooltip">
                                          <asp:ImageButton ID="imgBSTaiLieu" runat="server"
                                            ImageUrl="/UI/img/new.png" Width="21px"
                                            CommandArgument='<%#Eval("ID") %>' CommandName="ThemTL" />
                                         <asp:Literal ID="lttToolTipBSTaiLieu" runat="server"></asp:Literal>
                                    </div>
                                    <div class="tooltip">
                                        <asp:ImageButton ID="imgDel" runat="server"
                                            ImageUrl="/UI/img/delete.png" Width="21px"
                                            OnClientClick="return confirm('Bạn thực sự muốn xóa đơn khởi kiện này? ');"
                                            CommandArgument='<%#Eval("ID") %>' CommandName="Xoa" />
                                        <asp:Literal ID="lttTooltipXoa" runat="server"></asp:Literal>
                                    </div>

                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></table> </div></FooterTemplate>
                </asp:Repeater>

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
                            <asp:ListItem Value="10" Text="10" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="20" Text="20" ></asp:ListItem>
                            <asp:ListItem Value="30" Text="30"></asp:ListItem>
                            <asp:ListItem Value="50" Text="50"></asp:ListItem>
                            <asp:ListItem Value="100" Text="100"></asp:ListItem>
                            <asp:ListItem Value="200" Text="200"></asp:ListItem>
                            <asp:ListItem Value="500" Text="500"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </asp:Panel>
            <!-------------------------------------------->
        </div>
    </div>

    <script>
        function pageLoad(sender, args) {
            $(function () {
                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetAllToaNhanDKKOnline") %>';
                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan,
                            data: "{ 'textsearch': '" + request.term + "'}",
                            dataType: "json", type: "POST",
                            contentType: "application/json; charset=utf-8",

                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) },
                            error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddToaAnID]").val(i.item.val); }, minLength: 1
                });
            });

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script type="text/javascript">
        function Load_data_theodk() {
            $("#<%= cmdSearch.ClientID %>").click();
        }
        function change_control() {
            $("#<%= cmdSearch.ClientID %>").click();
            document.getElementById('<%=dropTrangThai.ClientID%>').focus();
        }
        $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13) {
                    $("#<%= cmdSearch.ClientID %>").click();
                }
            });
        });
    </script>
</asp:Content>
