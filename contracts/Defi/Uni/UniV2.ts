//

/**
 * 1. K值，不会变小，只会相等或者更大，从算法角度保证
 * 在实际的交易中，因为存在手续费和整型精度问题的影响，交易后的K值会有所改变
 * 在引入手续费后，同样数量的X能换到的Y，即就变少了，而加到池子中的X数量没有变化，所以就会稍大于，也就是说值会稍微增长。故乘积并不是严格的常数。
 *
 * 2. 无常损失
 * 无常损失（Impermanent Loss）是一种流动性供应商的暂时/非永久损失。当币价出现较大波动时，
 * 流动性供应商所持有的流动性份额所能兑换到的币的价值低于提供流动性时发送给池子的币的价值就叫做无常损失。
 * https://moomoolo.site/blog/uniswap-v2-core-explained
 *
 * 3.
 */