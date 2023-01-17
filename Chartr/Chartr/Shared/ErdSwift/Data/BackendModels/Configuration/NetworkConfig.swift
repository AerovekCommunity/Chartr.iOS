/*
The MIT License (MIT)

Copyright (c) 2023-present Aerovek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

struct NetworkConfig: Decodable {
    let config: Config
    
    struct Config: Decodable {
        let chainId: String
        let denomination: Int
        let gasPerDataByte: Int
        let gasPriceModifier: String
        let latestTagSoftwareVersion: String
        let metaConsensusGroupSize: Int64
        let minGasLimit: Int64
        let minGasPrice: Int64
        let minTransactionVersion: Int
        let numMetachainNodes: Int64
        let numNodesInShard: Int64
        let numShardsWithoutMeta: Int
        let rewardsTopUpGradientPoint: String
        let roundDuration: Int64
        let roundsPerEpoch: Int64
        let shardConsensusGroupSize: Int64
        let startTime: Int64
        let topUpFactor: String
        
        enum CodingKeys: String, CodingKey {
            case chainId = "erd_chain_id"
            case denomination = "erd_denomination"
            case gasPerDataByte = "erd_gas_per_data_byte"
            case gasPriceModifier = "erd_gas_price_modifier"
            case latestTagSoftwareVersion = "erd_latest_tag_software_version"
            case metaConsensusGroupSize = "erd_meta_consensus_group_size"
            case minGasLimit = "erd_min_gas_limit"
            case minGasPrice = "erd_min_gas_price"
            case minTransactionVersion = "erd_min_transaction_version"
            case numMetachainNodes = "erd_num_metachain_nodes"
            case numNodesInShard = "erd_num_nodes_in_shard"
            case numShardsWithoutMeta = "erd_num_shards_without_meta"
            case rewardsTopUpGradientPoint = "erd_rewards_top_up_gradient_point"
            case roundDuration = "erd_round_duration"
            case roundsPerEpoch = "erd_rounds_per_epoch"
            case shardConsensusGroupSize = "erd_shard_consensus_group_size"
            case startTime = "erd_start_time"
            case topUpFactor = "erd_top_up_factor"
        }
    }
}
